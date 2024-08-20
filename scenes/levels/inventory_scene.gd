extends Node2D

@onready var inventory = $inventory
const bottle_sprite = preload("res://assets/filament4.png")

func _ready():
	if Autoload.inventory_list.size():
		for idx in Autoload.inventory_list.size():
			if Autoload.inventory_list[idx].sprite:
				var texture = Autoload.inventory_list[idx].sprite
				var quantity = Autoload.inventory_list[idx].quantity
				inventory.get_child(idx).get_children()[1].texture = texture
				inventory.get_child(idx).get_children()[2].text = quantity
			inventory.get_child(idx).get_children()[0].text = str(idx)
		return
		
	for idx in inventory.get_child_count():
		inventory.get_child(idx).get_children()[0].text = str(idx)
		if idx > 8:
			Autoload.inventory_list.append({
				"idx": idx,
				"sprite": false,
			})
			continue
		
		var rng = RandomNumberGenerator.new()
		var random_text: String = str(rng.randi_range(10, 100))
		
		inventory.get_child(idx).get_children()[1].texture = bottle_sprite
		inventory.get_child(idx).get_children()[2].text = random_text
		
		Autoload.inventory_list.append(
			{
				"idx": idx,
				"sprite": bottle_sprite,
				"quantity": random_text
			}
		)
	Autoload.save_to_file()

func _on_main_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
