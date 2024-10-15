extends Node2D

@onready var container = $task_list_container
var texture = preload("res://assets/bottle.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	if not Worker.image_list.size():
		return
	
	for slot in container.get_children():
		if Worker.task_list.is_empty() or slot.get_index() > Worker.task_list.size():
			return
		if slot.get_index() < Worker.task_list.size():
			slot.get_child(0).text = str(slot.get_index())
			slot.get_child(1).texture = load(Worker.task_list[slot.get_index()].sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_main_scene_button_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/main.tscn")
