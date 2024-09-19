extends PanelContainer

@onready var sprite = $TextureRect
@onready var quantity_label = $Label
@onready var id_label = $id_label

func _get_drag_data(_at_position):
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
	
	# From task list to hotbar
	if current_item_path == "task_list_container" and target_item_path == "hotbar":
		#Worker.task_list.remove_at(int(current_id))
		var removed_item = Worker.task_list.pop_at(int(current_id))
		var current_obj = Autoload.game_data.hotbar[target_id]
		if current_obj.sprite:
			return
		Autoload.game_data.hotbar[target_id].sprite = str(removed_item.sprite)
		Autoload.game_data.hotbar[target_id].quantity = 0
	
	# From message box (printer obj) to hotbar
	if current_item_path == "hotbar" and target_item_path == "VBoxContainer":
		success = false
	elif current_item_path == "VBoxContainer" and target_item_path == "hotbar":
		success = false
	
	# INFO: hotbar --> printer. printer <---> printer, is disable
	if current_item_path == "hotbar" and target_item_path.to_lower().begins_with("printer"):
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.printer.duplicate(true)[target_id]
		if not target_slot.sprite:
			Autoload.game_data.printer[target_id].sprite = current_hotbar_item.sprite
			Autoload.game_data.printer[target_id].quantity = current_hotbar_item.quantity
			Autoload.game_data.hotbar[current_id].sprite = false
			Autoload.game_data.hotbar[current_id].erase("quantity")
			success = true
	# printer --> hotbar
	elif current_item_path.to_lower().begins_with("printer") and target_item_path == "hotbar":
		var current_printer_item = Autoload.game_data.printer.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		if not target_slot.sprite:
			Autoload.game_data.hotbar[target_id].sprite = current_printer_item.sprite
			Autoload.game_data.hotbar[target_id].quantity = current_printer_item.quantity
			Autoload.game_data.printer[current_id].sprite = false
			Autoload.game_data.printer[current_id].erase("quantity")
			success = true
	
	# INFO: inventory <--> inventory
	if current_item_path == "inventory" and target_item_path == "inventory":
		var current_inventory_item = Autoload.game_data.inventory.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.inventory.duplicate(true)[target_id]
		# target slot is empty
		if not target_slot.sprite:
			Autoload.game_data.inventory[target_id].sprite = str(current_inventory_item.sprite)
			Autoload.game_data.inventory[target_id].quantity = int(current_inventory_item.quantity)
			Autoload.game_data.inventory[current_id].sprite = false
			Autoload.game_data.inventory[current_id].erase("quantity")
		else:
			var temp_slot = target_slot
			Autoload.game_data.inventory[target_id].quantity = int(current_inventory_item.quantity)
			Autoload.game_data.inventory[target_id].sprite = str(current_inventory_item.sprite)
			Autoload.game_data.inventory[current_id].quantity = int(temp_slot.quantity)
			Autoload.game_data.inventory[current_id].sprite = str(temp_slot.sprite)
		success = true
	# INFO: inventory --> hotbar
	elif current_item_path == "inventory" and target_item_path == "hotbar":
		var current_inventory_item = Autoload.game_data.inventory.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		# target slot is empty
		if not target_slot.sprite:
			Autoload.game_data.hotbar[target_id].sprite = str(current_inventory_item.sprite)
			Autoload.game_data.hotbar[target_id].quantity = int(current_inventory_item.quantity)
			Autoload.game_data.inventory[current_id].sprite = false
			Autoload.game_data.inventory[current_id].erase("quantity")
		else:
			var temp_slot = target_slot
			Autoload.game_data.hotbar[target_id].quantity = int(current_inventory_item.quantity)
			Autoload.game_data.hotbar[target_id].sprite = str(current_inventory_item.sprite)
			Autoload.game_data.inventory[current_id].quantity = int(temp_slot.quantity)
			Autoload.game_data.inventory[current_id].sprite = str(temp_slot.sprite)
		success = true
	# INFO: hotbar <--> hotbar
	elif current_item_path == "hotbar" and target_item_path == "hotbar":
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.hotbar.duplicate(true)[target_id]
		# target slot is empty
		if not target_slot.sprite:
			Autoload.game_data.hotbar[target_id].sprite = str(current_hotbar_item.sprite)
			Autoload.game_data.hotbar[target_id].quantity = int(current_hotbar_item.quantity)
			Autoload.game_data.hotbar[current_id].sprite = false
			Autoload.game_data.hotbar[current_id].erase("quantity")
		else:
			var temp_slot = target_slot
			Autoload.game_data.hotbar[target_id].quantity = int(current_hotbar_item.quantity)
			Autoload.game_data.hotbar[target_id].sprite = str(current_hotbar_item.sprite)
			Autoload.game_data.hotbar[current_id].quantity = int(temp_slot.quantity)
			Autoload.game_data.hotbar[current_id].sprite = str(temp_slot.sprite)
		success = true
	# INFO: hotbar --> inventory
	elif current_item_path == "hotbar" and target_item_path == "inventory":
		var current_hotbar_item = Autoload.game_data.hotbar.duplicate(true)[current_id]
		var target_slot = Autoload.game_data.inventory.duplicate(true)[target_id]
		# target slot is empty
		if not target_slot.sprite:
			Autoload.game_data.inventory[target_id].sprite = str(current_hotbar_item.sprite)
			Autoload.game_data.inventory[target_id].quantity = int(current_hotbar_item.quantity)
			Autoload.game_data.hotbar[current_id].sprite = false
			Autoload.game_data.hotbar[current_id].erase("quantity")
		else:
			var temp_slot = target_slot
			Autoload.game_data.inventory[target_id].quantity = int(current_hotbar_item.quantity)
			Autoload.game_data.inventory[target_id].sprite = str(current_hotbar_item.sprite)
			Autoload.game_data.hotbar[current_id].quantity = int(temp_slot.quantity)
			Autoload.game_data.hotbar[current_id].sprite = str(temp_slot.sprite)
		success = true
	# WARNING: Remove element
	elif (current_item_path == "inventory" or current_item_path == "hotbar") and target_item_path2 == "delete_item":
		data.get_parent().get_children()[1].texture = null
		data.get_parent().get_children()[2].text = ""
		
		if current_item_path == "inventory":
			Autoload.game_data.inventory[current_id].sprite = false
			Autoload.game_data.inventory[current_id].erase("quantity")
		else:
			Autoload.game_data.hotbar[current_id].sprite = false
			Autoload.game_data.hotbar[current_id].erase("quantity")
		Autoload.save_to_file()
	
	if success:
		var temp_label = data.get_parent().get_children()[2].text
		data.get_parent().get_children()[2].text = quantity_label.text
		quantity_label.text = temp_label
		sprite.texture = data.texture
		data.texture = current_slot
		success = false
		Autoload.save_to_file()

func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = sprite.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
	return preview
