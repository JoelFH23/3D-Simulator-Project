extends Node2D
var thread: Thread

func _ready():
	pass

func _on_left_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/inventory_scene.tscn")

func _on_right_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/cabinet_scene.tscn")

func _on_run_thread_pressed():
	thread = Thread.new()
	thread.start(_thread_function.bind())

func _exit_tree():
	print("_exit_tree")

func _thread_function():
	var rng = RandomNumberGenerator.new()
	var random_n = rng.randi_range(1000,2500)
	print("waiting... ")
	OS.delay_msec(4500)
	print("I'm a thread! ")
