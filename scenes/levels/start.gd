extends Control

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/help.tscn")

func _on_exit_button_pressed():
	get_tree().quit()
