extends Node2D

@onready var inventory = $inventory
#const filament_sprite = preload("res://assets/filament4.png")

const filament_sprite = [
	preload("res://assets/filament4.png"),
	preload("res://assets/filament.png"),
	preload("res://assets/filament3.png")
]
func _ready():
	# when the inventory is not empty draw the filaments
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
	
	# Create 10 filaments when the inventory list is empty
	var inventory_list: Array = []
	for idx in inventory.get_child_count():
		inventory.get_child(idx).get_children()[0].text = str(idx)
		if idx <= 10:
			var random_sprite: CompressedTexture2D = filament_sprite.pick_random()
			var rng = RandomNumberGenerator.new()
			var random_text: String = str(rng.randi_range(10, 100))
			inventory.get_child(idx).get_children()[1].texture = random_sprite
			inventory.get_child(idx).get_children()[2].text = random_text
			inventory_list.append(
				{
					"idx": idx,
					"sprite": random_sprite.resource_path,
					"quantity": 100
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
