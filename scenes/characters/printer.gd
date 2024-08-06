extends CharacterBody2D

@onready var window = $Window
@onready var player = $container_button/CharacterBody2D/AnimatedSprite2D
@onready var label = $container_button/time_label
@onready var extrusion_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer/extrusion_temp_line_edit
@onready var bed_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer2/bed_temp_line_edit

var timer := Timer.new()
var stylebox_flat := StyleBoxFlat.new()
const MAX_RANDOM_SEGS: int = 5

func _close_window():
	window.hide()
	
func _open_window():
	if player.is_playing():
		player.stop()
	if not timer.is_stopped():
		print("the timer has been paused")
		timer.paused = true
	window.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	stylebox_flat.bg_color = Color(0,0,0)
	stylebox_flat.content_margin_top = 4
	stylebox_flat.content_margin_left = 4
	stylebox_flat.content_margin_right = 4
	stylebox_flat.content_margin_bottom = 4
	stylebox_flat.border_width_bottom = 1
	stylebox_flat.border_color = Color(255,0,0,0.2)
	
	bed_temp_line.add_theme_stylebox_override("normal",stylebox_flat)
	extrusion_temp_line.add_theme_stylebox_override("normal",stylebox_flat)
	
	#pause_button.visible = false
	timer.one_shot = true
	timer.timeout.connect(_reset_values)
	add_child(timer)
	_close_window()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = str(int(timer.time_left))

func _reset_values():
	player.stop()
	timer.stop()
	label.text = "0"

func _on_timer_timeout():
	if timer.paused:
		timer.paused = false
		player.play("walk_animation")
		return
	
	player.play("walk_animation")
	var rng = RandomNumberGenerator.new()
	var RANDOM_NUM = rng.randi_range(1,MAX_RANDOM_SEGS)
	label.text = str(RANDOM_NUM)
	timer.wait_time = RANDOM_NUM
	timer.start()

func _on_container_button_pressed():
	_open_window()

func _on_accept_button_pressed():
	"""
	if int(extrusion_temp_line.text) <= 0 or int(bed_temp_line.text) <= 0:
		_close_window()
		return
	"""
	print("Extrusion Temp: ", extrusion_temp_line.text)
	print("Bed Temp: ", bed_temp_line.text)
	_close_window()
	_on_timer_timeout()

func _on_pause_unpause():
	if timer.paused:
		timer.paused = false
		player.play("walk_animation")
	_close_window()

func _on_pause_button_pressed():
	_on_pause_unpause()

func _on_window_close_requested():
	_on_pause_unpause()

func _on_close_button_pressed():
	print("close")
	_on_pause_unpause()
