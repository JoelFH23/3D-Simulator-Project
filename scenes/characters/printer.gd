extends CharacterBody2D

@onready var window = $Window
@onready var player = $container_button/CharacterBody2D/AnimatedSprite2D
@onready var label = $container_button/time_label
@onready var extrusion_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer/extrusion_temp_line_edit
@onready var bed_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer2/bed_temp_line_edit
@onready var slot = $slot
@onready var printer_id = $slot/id_label

var timer := Timer.new()
var current_time: int = 0
var is_running: bool = false
signal update_label_text(text)
const MAX_RANDOM_SEGS: int = 5
var stylebox_flat := StyleBoxFlat.new()

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
	if Autoload.errors_list.size():
		print("ERROR: ", Autoload.errors_list.find(int(printer_id.text)))
	#if Autoload.game_data.printer[int(slot.id_label.text)].sprite:
		#slot.quantity_label.text = str(Autoload.game_data.printer[int(slot.id_label.text)].quantity)

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
		idx += 1
		OS.delay_msec(250)
		print("done!")
	print("finished!")
	#call_deferred("_emit_update_label_text", "0")
	is_running = false

func _on_accept_button_pressed():
	"""
	if int(extrusion_temp_line.text) <= 0 or int(bed_temp_line.text) <= 0:
		label.text = "FAILED!"
		_close_window()
		return
	"""
	
	if int(slot.quantity_label.text) <= 0:
		label.text = "FAILED!"
		return
	_close_window()
	
	print("Extrusion Temp: ", extrusion_temp_line.text)
	print("Bed Temp: ", bed_temp_line.text)
	label.text = ""
	
	for idx in Autoload.printer_info_list.size():
		if int(Autoload.printer_info_list[idx].id) == int(slot.id_label.text):
			Autoload.printer_info_list.remove_at(idx)
	
	Autoload.start_worker(int(slot.id_label.text))
	Autoload.printer_info_list.append({
		"id": int(slot.id_label.text),
		"ext_temp": int(extrusion_temp_line.text),
		"bed_temp": int(bed_temp_line.text)
	})

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


func _on_texture_button_pressed() -> void:
	print("button pressed!")
