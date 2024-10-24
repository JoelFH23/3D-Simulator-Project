extends CharacterBody2D

@onready var window = $Window
@onready var label = $container_button/time_label
@onready var extrusion_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer/extrusion_temp_line_edit
@onready var bed_temp_line = $Window/MarginContainer/VBoxContainer/HBoxContainer2/bed_temp_line_edit
@onready var filament_slot = $filament_slot
@onready var figure_slot = $Window/MarginContainer/VBoxContainer/figure_slot
@onready var status_label = $Window/MarginContainer/VBoxContainer/status_label
@onready var printer_id = $printer_id_label

var stylebox_flat := StyleBoxFlat.new()

func _close_window():
	window.hide()
	
func _open_window():
	window.show()

func _ready():
	window.exclusive = true
	window.unresizable = true
	window.popup_window = true
	window.title = "Printer " + str(printer_id.text)
	stylebox_flat.bg_color = Color(0,0,0)
	stylebox_flat.content_margin_top = 4
	stylebox_flat.content_margin_left = 4
	stylebox_flat.content_margin_right = 4
	stylebox_flat.content_margin_bottom = 4
	stylebox_flat.border_width_bottom = 1
	stylebox_flat.border_color = Color(255,0,0,0.2)
	
	bed_temp_line.add_theme_stylebox_override("normal",stylebox_flat)
	extrusion_temp_line.add_theme_stylebox_override("normal",stylebox_flat)
	_close_window()

func _process(_delta):
	for printer in Autoload.game_data.printer:
		if printer.idx == int(printer_id.text):
			if printer.figure_slot:
				figure_slot.get_children()[1].texture = load(printer.figure_slot.sprite)
			if printer.filament_slot:
				filament_slot.get_children()[2].text = str(printer.filament_slot.quantity)
			status_label.text = printer.status

func _reset_values():
	label.text = "0"

func _on_container_button_pressed():
	_open_window()

func _on_accept_button_pressed():
	"""
	if int(extrusion_temp_line.text) <= 0 or int(bed_temp_line.text) <= 0:
		current_printer.status = "FAILED!"
		_close_window()
		return
	"""
	var current_printer = Autoload.game_data.printer[int(printer_id.text)]
	
	if current_printer.figure_slot:
		current_printer.status = "FAIL"
		return
	if not current_printer.file or not current_printer.filament_slot:
		current_printer.status = "NO FILAMENT OR FILE"
		return
	if int(current_printer.filament_slot.quantity) <= 0:
		current_printer.status = "NO FILAMENT"
		return
	
	_close_window()
	current_printer.status = "running..."
	Autoload.start_worker(int(printer_id.text))

func _on_pause_unpause():
	_close_window()

func _on_window_close_requested():
	_close_window()

func _on_close_button_pressed():
	_on_pause_unpause()

func _update_window_slot():
	pass

func _on_window_visibility_changed():
	pass
