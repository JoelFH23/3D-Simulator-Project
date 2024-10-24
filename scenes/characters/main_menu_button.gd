extends Button

func _on_main_menu_pressed():
	Autoload.is_close = true
	get_tree().change_scene_to_file("res://scenes/levels/start.tscn")
