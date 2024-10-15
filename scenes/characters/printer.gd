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
	pass
	"""
	if Autoload.errors_list.size():
		print("ERROR: ", Autoload.errors_list.find(int(filament_slot.id_label.text)))
	
	if Autoload.game_data.printer[int(filament_slot.id_label.text)].sprite:
		filament_slot.quantity_label.text = str(Autoload.game_data.printer[int(filament_slot.id_label.text)].quantity)
		
		for printer in Autoload.game_data.printer:
			if int(printer.idx) == int(filament_slot.id_label.text):
				status_label.text = printer.figure.status
	"""

func _reset_values():
	label.text = "0"

func _on_container_button_pressed():
	_open_window()

func _on_accept_button_pressed():
	"""
	if int(extrusion_temp_line.text) <= 0 or int(bed_temp_line.text) <= 0:
		label.text = "FAILED!"
		_close_window()
		return
	"""
	
	"""
	if int(filament_slot.quantity_label.text) <= 0 or figure_slot.sprite.texture == null:
		for idx in Autoload.game_data.printer.size():
			if int(Autoload.game_data.printer[idx].idx) == int(filament_slot.id_label.text):
				Autoload.game_data.printer[idx].figure.status = "FAIL"
				Autoload.game_data.printer[idx].figure.bed_temp = 0
				Autoload.game_data.printer[idx].figure.ext_temp = 0
		return
	"""
	
	_close_window()
	for printer in Autoload.game_data.printer:
		if printer.idx == int(printer_id.text):
			printer.bed_temp = int(bed_temp_line.text)
			printer.ext_temp = int(extrusion_temp_line.text)
			printer.status = "running..."
	"""
	print("figure_slot: ", figure_slot.sprite.texture.resource_path)
	print("Extrusion Temp: ", extrusion_temp_line.text)
	print("Bed Temp: ", bed_temp_line.text)
	"""
	
	"""
	for idx in Autoload.game_data.printer.size():
		if int(Autoload.game_data.printer[idx].idx) == int(filament_slot.id_label.text):
			if Autoload.game_data.printer[idx].figure.status == "running...":
				return
			Autoload.game_data.printer[idx].figure.status = "running..."
			Autoload.game_data.printer[idx].figure.bed_temp = int(bed_temp_line.text)
			Autoload.game_data.printer[idx].figure.ext_temp = int(extrusion_temp_line.text)
	"""
	
	#Autoload.start_worker(int(filament_slot.id_label.text))

func _on_pause_unpause():
	_close_window()

func _on_window_close_requested():
	_on_pause_unpause()

func _on_close_button_pressed():
	_on_pause_unpause()
