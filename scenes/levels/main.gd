extends Node2D
@onready var printerContainer = $printers/PrinterContainer
@onready var scoreLabel = $score_label

func _process(_delta):
	pass

func _ready():
	scoreLabel.text = "SCORE: " + str(Autoload.score)
	#if not Autoload.game_data.printer.size():
	if false:
		var _printer_list: Array = []
		for idx in printerContainer.get_child_count():
			printerContainer.get_child(idx).get_children()[0].get_children()[0].text = str(idx)
		"""
			printer_list.append({
				"idx": idx,
				"sprite": false,
				"figure": false
			})
		Autoload.game_data.printer = printer_list
		Autoload.save_to_file()
		"""

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/inventory_scene.tscn")

func _on_right_button_pressed():
	#get_tree().change_scene_to_file("res://scenes/levels/cabinet_scene.tscn")
	get_tree().change_scene_to_file("res://scenes/levels/tasks_scene.tscn")

func _exit_tree():
	pass
