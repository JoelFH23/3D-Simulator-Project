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
	var current_id = int(data.get_parent().get_children()[0].text)
	var target_id = int(id_label.text)
	var success = false
	
	var current_item_path = str(data.get_path()).split("/")[str(data.get_path()).split("/").size() - 3]
	var target_item_path = str(sprite.get_path()).split("/")[str(sprite.get_path()).split("/").size() - 3]
	var target_item_path2 = str(sprite.get_path()).split("/")[str(sprite.get_path()).split("/").size() - 2]
	
	# hotbar --> printer
	if current_item_path == "hotbar" and target_item_path.to_lower().begins_with("printer"):
		var temp_item = Autoload.game_data.hotbar[current_id]
		Autoload.game_data.hotbar[current_id] = Autoload.game_data.printer[target_id]
		Autoload.game_data.printer[target_id] = temp_item
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
		Autoload.start_worker(str(target_id))
	# printer --> hotbar
	elif current_item_path.to_lower().begins_with("printer") and target_item_path == "hotbar":
		var temp_item = Autoload.game_data.printer[current_id]
		Autoload.game_data.printer[current_id] = Autoload.game_data.hotbar[target_id]
		Autoload.game_data.hotbar[target_id] = temp_item
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
		
	if current_item_path == "inventory" and target_item_path == "inventory":
		var target_slot = Autoload.game_data.inventory[target_id]
		Autoload.game_data.inventory[target_id] = Autoload.game_data.inventory[current_id]
		Autoload.game_data.inventory[current_id] = target_slot
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
	
	elif current_item_path == "hotbar" and target_item_path == "hotbar":
		var target_slot = Autoload.game_data.hotbar[target_id]
		Autoload.game_data.hotbar[target_id] = Autoload.game_data.hotbar[current_id]
		Autoload.game_data.hotbar[current_id] = target_slot
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
	
	elif current_item_path == "inventory" and target_item_path == "hotbar":
		var current_inventory_item = Autoload.game_data.inventory[current_id]
		
		if Autoload.game_data.hotbar[target_id].sprite:
			Autoload.game_data.inventory[current_id] = Autoload.game_data.hotbar[target_id]
			Autoload.game_data.hotbar[target_id] = current_inventory_item
		else:
			Autoload.game_data.hotbar[target_id] = current_inventory_item
			Autoload.game_data.inventory[current_id] = {
				"idx": str(target_id),
				"sprite": false
			}
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
	
	elif current_item_path == "hotbar" and target_item_path == "inventory":
		var current_inventory_item = Autoload.game_data.inventory[target_id]
		var current_hotbar_item = Autoload.game_data.hotbar[current_id]
		
		if Autoload.game_data.inventory[target_id].sprite:
			Autoload.game_data.hotbar[current_id] = current_inventory_item
			Autoload.game_data.inventory[target_id] = current_hotbar_item
		else:
			Autoload.game_data.inventory[target_id] = current_hotbar_item
			Autoload.game_data.hotbar[current_id] = {
				"idx": str(current_id),
				"sprite": false
			}
		sprite.texture = data.texture
		data.texture = current_slot
		success = true
	
	elif (current_item_path == "inventory" or current_item_path == "hotbar") and target_item_path2 == "delete_item":
		data.get_parent().get_children()[0].text = ""
		data.get_parent().get_children()[1].texture = null
		data.get_parent().get_children()[2].text = ""
		
		if current_item_path == "inventory":
			Autoload.game_data.inventory[current_id] = {
				"idx": str(current_id),
				"sprite": false,
			}
		else:
			Autoload.game_data.hotbar[current_id] = {
				"idx": str(current_id),
				"sprite": false,
			}
		success = true
	
	if success:
		var temp_label = data.get_parent().get_children()[2].text
		data.get_parent().get_children()[2].text = quantity_label.text
		quantity_label.text = temp_label
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
