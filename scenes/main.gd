extends Node2D

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/inventory_scene.tscn")

func _on_right_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/cabinet_scene.tscn")
