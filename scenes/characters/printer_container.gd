extends Node2D

@onready var container = $PrinterContainer

func _ready():
	for idx in Autoload.game_data.printer.size():
		container.get_child(idx).get_children()[0].get_children()[0].text = str(idx)
		if Autoload.game_data.printer[idx].sprite:
			var texture = Autoload.game_data.printer[idx].sprite
			var quantity = Autoload.game_data.printer[idx].quantity
			container.get_child(idx).get_children()[0].get_children()[1].texture = load(texture)
			container.get_child(idx).get_children()[0].get_children()[2].text = str(quantity)
			print("idx: ",container.get_child(idx).get_children())
