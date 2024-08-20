extends HBoxContainer

@onready var hotbar = $MarginContainer/hotbar

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Autoload.hotbar_list.size():
		for idx in hotbar.get_child_count():
			Autoload.hotbar_list.append({
				"idx": str(idx),
				"sprite": false,
			})
	for idx in Autoload.hotbar_list.size():
		if Autoload.hotbar_list[idx].sprite:
			var texture = Autoload.hotbar_list[idx].sprite
			var quantity = Autoload.hotbar_list[idx].quantity
			hotbar.get_child(idx).get_children()[1].texture = texture
			hotbar.get_child(idx).get_children()[2].text = quantity
		hotbar.get_child(idx).get_children()[0].text = str(idx)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
