extends CharacterBody2D

@onready var window = $Window
@onready var player = $container_button/CharacterBody2D/AnimatedSprite2D
@onready var label = $container_button/time_label
@onready var extrusion_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer/extrusion_temp_line_edit
@onready var bed_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer2/bed_temp_line_edit

var timer := Timer.new()
var stylebox_flat := StyleBoxFlat.new()
const MAX_RANDOM_SEGS: int = 5

var current_time: int = 0

var is_running: bool = false
signal update_label_text(text)

func _close_window():
	window.hide()
	
func _open_window():
	if player.is_playing():
		player.stop()
	if not timer.is_stopped():
		print("the timer has been paused")
		timer.paused = true
	window.show()

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
	
	timer.one_shot = true
	timer.timeout.connect(_reset_values)
	add_child(timer)
	_close_window()
	connect("update_label_text", _on_update_label_text)

func _process(_delta):
	#label.text = str(current_time)
	pass

func _reset_values():
	player.stop()
	timer.stop()
	label.text = "0"

func _on_container_button_pressed():
	_open_window()

func _emit_update_label_text(text: String):
	emit_signal("update_label_text", text)

func _on_update_label_text(_text: String):
	#label.text = str(text)
	pass

func _on_timeout():
	var idx: int = 0
	while idx != 25:
		print("waiting... ", idx)
		#print(Time.get_datetime_string_from_system()," Done!")
		#call_deferred("_emit_update_label_text", str(idx))
		#current_time = idx
		idx += 1
		OS.delay_msec(250)
		print("done!")
	print("finished!")
	#call_deferred("_emit_update_label_text", "0")
	is_running = false
	"""
	while true:
		print("I'm a thread")
		OS.delay_msec(500)
		print("Done!")
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
	"""

func _on_accept_button_pressed():
	"""
	if int(extrusion_temp_line.text) <= 0 or int(bed_temp_line.text) <= 0:
		_close_window()
		return
	"""
	_close_window()
	
	print("Extrusion Temp: ", extrusion_temp_line.text)
	print("Bed Temp: ", bed_temp_line.text)
	
	var task_id = Autoload.workerThreadPool.add_task(_on_timeout)
	print("running: ", task_id)
	
	"""
	var thread = Thread.new()
	print("Thread is alive: ", thread.is_alive())
	thread.start(Autoload.on_press_button)
	if is_running:
		return
	
	return
	is_running = true
	"""
	#var thread = Thread.new()
	#print("Thread_id: ", thread.is_alive())
	#print("thread: ", thread.is_alive())
	#thread.start(Autoload.on_press_button)

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
	_on_pause_unpause()
