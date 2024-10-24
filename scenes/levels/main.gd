extends Node2D
@onready var printerContainer = $printers/PrinterContainer

func _process(_delta):
	pass

func _ready():
	if false:
		for idx in printerContainer.get_child_count():
			printerContainer.get_child(idx).get_children()[0].get_children()[0].text = str(idx)

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/inventory_scene.tscn")

func _on_right_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/tasks_scene.tscn")

func _exit_tree():
	pass
