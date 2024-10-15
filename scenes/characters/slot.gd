extends PanelContainer

@onready var sprite = $sprite
@onready var quantity_label = $quantity_label
@onready var id_label = $id_label

func _get_drag_data(_at_position):
	if sprite.texture == null or (sprite.texture != null and str(sprite.texture.resource_path).split('/')[-1] == "trash_can.png"):
		return
	set_drag_preview(get_preview())
	return sprite

func _can_drop_data(_pos, data):
	return data is TextureRect

func _drop_data(_pos, data) -> void:
	if data.texture == null:
		return
	
	var current_slot: CompressedTexture2D = sprite.texture
	var current_id: int = int(data.get_parent().get_children()[0].text)
	var target_id: int = int(id_label.text)
	var success: bool = false
	
	var current_item_path = str(data.get_path()).split("/")[str(data.get_path()).split("/").size() - 3]
	var target_item_path = str(sprite.get_path()).split("/")[str(sprite.get_path()).split("/").size() - 3]
	var target_item_path2 = str(sprite.get_path()).split("/")[str(sprite.get_path()).split("/").size() - 2]
	
	print("current_item_path: ", current_item_path)
	print("target_item_path: ", target_item_path)
	print("target_item_path2: ", target_item_path2)
	
	# GET COINS
	if current_item_path == "hotbar" and target_item_path2 == "sell_slot":
		if not Autoload.game_data.hotbar[current_id].figure_slot:
			print("INVALID ITEM!")
			return
		Autoload.game_data.hotbar[current_id].figure_slot = false
		success = true
	
	###################### FILE ######################
	if current_item_path == "hotbar" and target_item_path == "document_slot":
		if not Autoload.game_data.hotbar[current_id].file:
			print("INVALID ITEM!")
			return
		var current_priter_str = str(sprite.get_path()).split('/')[5].split("Printer")[1]
		var current_priter_id = (1 if current_priter_str == "" else int(current_priter_str)) -1
		Autoload.game_data.printer[current_priter_id].file = Autoload.game_data.hotbar[current_id].file
		Autoload.game_data.hotbar[current_id].file = false
		success = true
	elif current_item_path == "document_slot" and target_item_path == "hotbar":
		#var current_priter_str = str(data.get_path()).split('/')[5].split("Printer")[1]
		#var current_priter_id = (1 if current_priter_str == "" else int(current_priter_str))
		Autoload.game_data.hotbar[target_id].file = Autoload.game_data.printer[current_id].file
		Autoload.game_data.printer[current_id].file = false
		success = true
	
	###################### TASK LIST ######################
	if current_item_path == "task_list_container" and target_item_path == "hotbar":
		var removed_item = Worker.task_list.pop_at(int(current_id))
		var target_obj = Autoload.game_data.hotbar[target_id]
		
		if target_obj.figure_slot or target_obj.filament_slot or target_obj.file:
			print("target object is not empty!")
			return
		Worker.temp_task_list.append(removed_item)
		Autoload.game_data.hotbar[target_id].file = removed_item
		success = true
	
	###################### MessageBox (Pop-up) ######################
	if current_item_path == "hotbar" and target_item_path == "VBoxContainer":
		if int(Autoload.game_data.hotbar[current_id].quantity):
			return
		var current_priter_str = str(sprite.get_path()).split('/')[5].split("Printer")[1]
		var current_priter_id = (1 if current_priter_str == "" else int(current_priter_str)) -1
		if Autoload.game_data.printer[current_priter_id].figure.sprite:
			print("slot is not empty: ",Autoload.game_data.printer[current_priter_id].figure)
			return
		print("current_printer: ",Autoload.game_data.printer[current_priter_id])
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[current_id]
		Autoload.game_data.printer[current_priter_id].figure.sprite = target_slot.sprite
		Autoload.game_data.hotbar[current_id].sprite = false
		Autoload.game_data.hotbar[current_id].erase("quantity")
		success = true
	# From messageBox to hotbar
	elif current_item_path == "VBoxContainer" and target_item_path == "hotbar":
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		if target_slot.sprite:
			print("target slot is not empty")
			return
		var current_priter_str = str(data.get_path()).split('/')[5].split("Printer")[1]
		var current_priter_id = (1 if current_priter_str == "" else int(current_priter_str)) -1
		var current_priter = Autoload.game_data.printer.duplicate(true)[current_priter_id]

			#if int(item.printer_id) == int(current_priter_id):
		#print("current_printer: ", Autoload.printer_info_list[current_priter_id])
		Autoload.game_data.printer[current_priter_id].figure.bed_temp = 0
		Autoload.game_data.printer[current_priter_id].figure.ext_temp = 0
		Autoload.game_data.printer[current_priter_id].figure.sprite = false
		Autoload.game_data.printer[current_priter_id].figure.status = "ON"
		Autoload.game_data.hotbar[target_id].figure = current_priter.figure
		Autoload.game_data.hotbar[target_id].sprite = current_priter.figure.sprite
		Autoload.game_data.hotbar[target_id].quantity = 0
		success = true
	
	###################### PRINTER (filament) ######################
	# INFO: hotbar --> printer. printer <---> printer, is disable
	if current_item_path == "hotbar" and target_item_path.to_lower().begins_with("printer"):
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.printer.duplicate(true)[target_id]
		if not current_hotbar_item.filament_slot or target_slot.filament_slot:
			print("INVALID ITEM!")
			return
		Autoload.game_data.hotbar[current_id].filament_slot = false
		Autoload.game_data.hotbar[current_id].figure_slot = false
		Autoload.game_data.printer[target_id].filament_slot = current_hotbar_item.filament_slot
		Autoload.game_data.printer[target_id].figure_slot = current_hotbar_item.figure_slot
		success = true
	# printer --> hotbar
	elif current_item_path.to_lower().begins_with("printer") and target_item_path == "hotbar":
		var current_printer_item = Autoload.game_data.printer.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		if target_slot.filament_slot or target_slot.figure_slot:
			print("TARGET SLOT IS NOT EMPTY!")
			return
		Autoload.game_data.printer[current_id].filament_slot = false
		Autoload.game_data.printer[current_id].figure_slot = false
		Autoload.game_data.hotbar[target_id].filament_slot = current_printer_item.filament_slot
		Autoload.game_data.hotbar[target_id].figure_slot = current_printer_item.figure_slot
		success = true
	
	###################### ITEMS ######################
	# INFO: inventory <--> inventory
	if current_item_path == "inventory" and target_item_path == "inventory":
		var current_inventory_item = Autoload.game_data.inventory.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.inventory.duplicate(true)[target_id]
		var temp_slot = current_inventory_item
		Autoload.game_data.inventory[current_id].filament_slot = target_slot.filament_slot
		Autoload.game_data.inventory[current_id].figure_slot = target_slot.figure_slot
		Autoload.game_data.inventory[target_id].filament_slot = temp_slot.filament_slot
		Autoload.game_data.inventory[target_id].figure_slot = temp_slot.figure_slot
		success = true
	# INFO: inventory --> hotbar
	elif current_item_path == "inventory" and target_item_path == "hotbar":
		var current_inventory_item = Autoload.game_data.inventory.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		var temp_slot = current_inventory_item
		Autoload.game_data.inventory[current_id].filament_slot = target_slot.filament_slot
		Autoload.game_data.inventory[current_id].figure_slot = target_slot.figure_slot
		Autoload.game_data.hotbar[target_id].filament_slot = temp_slot.filament_slot
		Autoload.game_data.hotbar[target_id].figure_slot = temp_slot.figure_slot
		success = true
	# INFO: hotbar <--> hotbar
	elif current_item_path == "hotbar" and target_item_path == "hotbar":
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		var temp_slot = current_hotbar_item
		Autoload.game_data.hotbar[current_id].filament_slot = target_slot.filament_slot
		Autoload.game_data.hotbar[current_id].figure_slot = target_slot.figure_slot
		Autoload.game_data.hotbar[target_id].filament_slot = temp_slot.filament_slot
		Autoload.game_data.hotbar[target_id].figure_slot = temp_slot.figure_slot
		success = true
	# INFO: hotbar --> inventory
	elif current_item_path == "hotbar" and target_item_path == "inventory":
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.inventory.duplicate(true)[target_id]
		var temp_slot = current_hotbar_item
		Autoload.game_data.hotbar[current_id].filament_slot = target_slot.filament_slot
		Autoload.game_data.hotbar[current_id].figure_slot = target_slot.figure_slot
		Autoload.game_data.inventory[target_id].filament_slot = temp_slot.filament_slot
		Autoload.game_data.inventory[target_id].figure_slot = temp_slot.figure_slot
		success = true
	
	###################### REMOVE ELEMETS ######################
	elif (current_item_path == "inventory" or current_item_path == "hotbar") and target_item_path2 == "delete_item":
		data.get_parent().get_children()[1].texture = null
		data.get_parent().get_children()[2].text = ""
		
		if current_item_path == "inventory":
			Autoload.game_data.inventory[current_id] = {
				"idx": int(current_id), 
				"figure_slot": false,
				"filament_slot": false
			}
		else:
			Autoload.game_data.hotbar[current_id] = {
				"idx": int(current_id), 
				"figure_slot": false,
				"filament_slot": false
			}
		Autoload.save_to_file()
	
	if success:
		var temp_label = data.get_parent().get_children()[2].text
		data.get_parent().get_children()[2].text = quantity_label.text
		quantity_label.text = temp_label
		sprite.texture = data.texture
		data.texture = current_slot
		Autoload.save_to_file()
		success = false

func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = sprite.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
	return preview
