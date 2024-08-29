extends Node2D

@onready var printerContainer = $HBoxPrinterContainer/PrinterMarginContainer
const FILE_PATH = "res://printer.save"

func _ready():
	if not Autoload.game_data.printer.size():
		var printer_list: Array = []
		for idx in printerContainer.get_child_count():
			printerContainer.get_child(idx).get_children()[1].get_children()[0].text = str(idx)
			printer_list.append({
				"idx": idx,
				"sprite": false
			})
		Autoload.game_data["printer"] = printer_list
		Autoload.save_to_file()
		return
	
	for idx in Autoload.game_data.printer.size():
		printerContainer.get_child(idx).get_children()[1].get_children()[0].text = str(idx)
		if Autoload.game_data.printer[idx].sprite:
			var texture = Autoload.game_data.printer[idx].sprite
			var quantity = Autoload.game_data.printer[idx].quantity
			printerContainer.get_child(idx).get_children()[1].get_children()[1].texture = load(texture)
			printerContainer.get_child(idx).get_children()[1].get_children()[2].text = str(quantity)

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/inventory_scene.tscn")

func _on_right_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/cabinet_scene.tscn")

func _exit_tree():
	print("_exit_tree")
