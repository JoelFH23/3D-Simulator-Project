extends Node2D

@onready var container = $PrinterContainer
@onready var figureSlot = $PrinterContainer/Printer/Window/MarginContainer/VBoxContainer/figure_slot
@onready var document_slot = $PrinterContainer/Printer/document_slot

func _ready():
	#for idx in Autoload.game_data.printer.size():
	if not Autoload.game_data.printer.size():
		for idx in container.get_child_count():
			Autoload.game_data.printer.append({
				"idx": idx,
				"filament_slot":false,
				"figure_slot": false,
				"file": false,
				"bed_temp": 0,
				"ext_temp": 0,
				"status": "ON"
			})
		Autoload.save_to_file()
	
	for idx in container.get_child_count():
		container.get_child(idx).get_children()[0].text = str(idx)
		container.get_child(idx).get_children()[1].get_children()[0].text = str(idx)
		container.get_child(idx).get_children()[3].get_children()[0].get_children()[0].text = str(idx)
		if Autoload.game_data.printer[idx].filament_slot:
			var texture = Autoload.game_data.printer[idx].filament_slot.sprite
			var quantity = Autoload.game_data.printer[idx].filament_slot.quantity
			container.get_child(idx).get_children()[1].get_children()[1].texture = load(texture)
			container.get_child(idx).get_children()[1].get_children()[2].text = str(quantity)
		if Autoload.game_data.printer[idx].file:
			var texture = Autoload.game_data.printer[idx].file.sprite
			container.get_child(idx).get_children()[3].get_children()[0].get_children()[1].texture = load(texture)
			print(Autoload.game_data.printer[idx].file.sprite)
		"""
		if Autoload.game_data.printer[idx].figure.sprite:
			container.get_child(idx).get_children()[3].get_children()[0].get_children()[0].get_children()[2].sprite.texture = load(Autoload.game_data.printer[idx].figure.sprite)
		"""
