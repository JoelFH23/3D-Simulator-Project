extends HBoxContainer

@onready var hotbar = $MarginContainer/hotbar

# Called when the node enters the scene tree for the first time.
func _ready():
	var hotbar_list: Array = []
	if not Autoload.game_data.hotbar.size():
		for idx in hotbar.get_child_count():
			hotbar_list.append({
				"idx": idx,
				"figure_slot": false,
				"filament_slot": false,
				"file": false
			})
		Autoload.game_data["hotbar"] = hotbar_list
		Autoload.save_to_file()
		return
	for idx in Autoload.game_data.hotbar.size():
		if Autoload.game_data.hotbar[idx].filament_slot:
			var texture = Autoload.game_data.hotbar[idx].filament_slot.sprite
			var quantity = Autoload.game_data.hotbar[idx].filament_slot.quantity
			hotbar.get_child(idx).get_children()[2].text = str(quantity)
			hotbar.get_child(idx).get_children()[1].texture = load(texture)
		elif Autoload.game_data.hotbar[idx].file:
			var texture = Autoload.game_data.hotbar[idx].file.sprite
			hotbar.get_child(idx).get_children()[1].texture = load(texture)
		hotbar.get_child(idx).get_children()[0].text = str(idx)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
