extends Node2D

#@onready var inventory = $inventory

# Called when the node enters the scene tree for the first time.
func _ready():
	var new_texture = TextureRect.new()
	new_texture.texture = load("res://assets/orange.png")
	new_texture.expand_mode = 1 # ignore size
	new_texture.size = Vector2(40,40)
	new_texture.stretch_mode = 0
	
	"""
	var sprites = [
		load("res://assets/coconut.png"),
		load("res://assets/banana.png"),
		load("res://assets/cherry.png"),
		load("res://assets/orange.png")
	]
	# fill inventory (only for test)
	for item in inventory.get_children():
		var rng = RandomNumberGenerator.new()
		if rng.randi_range(0, 1):
			continue
		
		item.get_children()[0].texture = sprites.pick_random()
		item.get_children()[1].text = str(rng.randi_range(0, 100))
	"""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_main_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
