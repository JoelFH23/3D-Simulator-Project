extends Node2D

@onready var inventory = $inventory
const filament_sprite = preload("res://assets/filament4.png")

func load_file():
	var json_as_text = FileAccess.get_file_as_string("res://file_data.json")
	var json_as_dict = JSON.parse_string(json_as_text)
	for item in json_as_dict.printers:
		pass

func _ready():
	if not Autoload.game_data.inventory.is_empty():
		for idx in Autoload.game_data.inventory.size():
			inventory.get_child(idx).get_children()[0].text = str(idx)
			if Autoload.game_data.inventory[idx].sprite:
				var texture = Autoload.game_data.inventory[idx].sprite
				var quantity = Autoload.game_data.inventory[idx].quantity
				inventory.get_child(idx).get_children()[1].texture = load(texture)
				inventory.get_child(idx).get_children()[2].text = str(quantity)
			inventory.get_child(idx).get_children()[0].text = str(idx)
		return
	
	var inventory_list: Array = []
	for idx in inventory.get_child_count():
		inventory.get_child(idx).get_children()[0].text = str(idx)
		if idx <= 10:
			var rng = RandomNumberGenerator.new()
			var random_text: String = str(rng.randi_range(10, 100))
			inventory.get_child(idx).get_children()[1].texture = filament_sprite
			inventory.get_child(idx).get_children()[2].text = random_text
			inventory_list.append(
				{
					"idx": idx,
					"sprite": filament_sprite.resource_path,
					"quantity": random_text
				}
			)
			continue
		inventory_list.append({
			"idx": idx,
			"sprite": false,
		})
	Autoload.game_data["inventory"] = inventory_list
	Autoload.save_to_file()

func _on_main_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
