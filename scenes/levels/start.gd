extends Control
@onready var playButton = $MarginContainer/VBoxContainer/play_button

func _ready():
	playButton.text = "Continue Game" if Autoload.is_close else playButton.text

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
	Autoload.is_close = false

func _on_help_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menu/help.tscn")

func _on_exit_button_pressed():
	get_tree().quit()

func _on_reset_button_pressed():
	Autoload._reset_game()
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
