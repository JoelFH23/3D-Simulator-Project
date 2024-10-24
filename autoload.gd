extends Node

var mutex = Mutex.new()
var hotbar_list: Array[Dictionary]
var inventory_list: Array[Dictionary]
var workerThreadPool = WorkerThreadPool
var game_data: Dictionary = {"inventory":[],"hotbar":[],"printer":[]}
var errors_list: Array
var printer_info_list: Array = []
var random_figures_list: Array = []
var score = 0
var is_close = false
const FILE_PATH = "res://data//game_data.json"
const MAX_SIZE = 20
var image_list: Array = [
	"res://assets/figures/bottle.png",
	"res://assets/figures/milk.png",
	"res://assets/figures/gold_ingot.png",
]
var figure_error = "res://assets/figures/plasta.png"

func _remove_elements():
	for idx in game_data.printer.size():
		game_data.printer[idx].file = false
		
	for idx in game_data.hotbar.size():
		game_data.hotbar[idx].file = false
	
	save_to_file()
	
func random_figures():
	"""create random items """
	var id = 0
	while true:
		if random_figures_list.size() == MAX_SIZE:
			OS.delay_msec(5000)
			continue
		var rng = RandomNumberGenerator.new()
		random_figures_list.append({
			"figure_id": id,
			"sprite": image_list.pick_random(),
			"pts": rng.randi_range(5, 30),
			"status": "uncompleted"
		})
		id += 1
		OS.delay_msec(1500)

func _notification(what):
	"""save game when app is closed"""
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		get_tree().quit()

func run_printer_task(printer_id: int):
	var printer = game_data.printer[printer_id]
	var block_size = 0
	var total = 50
	var fail: bool = false
	mutex.lock()
	var figure_slot = random_figures_list.pop_front()
	mutex.unlock()
	
	while block_size <= total:
		var percent = (float(block_size) / total) * 100
		printer.filament_slot.quantity -= 1
		if printer.filament_slot.quantity <= 0:
			fail = true
			break
		printer.status = str(percent) + "%"
		block_size += 1
		OS.delay_msec(40)
	
	mutex.lock()
	if fail:
		figure_slot.sprite = figure_error
		figure_slot.pts = 0
		figure_slot.status = "error"
		printer.figure_slot = figure_slot
	else:
		figure_slot.status = "success"
		printer.figure_slot = figure_slot
	save_to_file()
	mutex.unlock()

func _reset_game():
	score = 0
	Worker.task_list.clear()
	
	for hotbar in game_data.hotbar:
		if hotbar.figure_slot:
			hotbar.figure_slot = false
		if hotbar.filament_slot:
			hotbar.filament_slot = false
		if hotbar.file:
			hotbar.file = false
	
	game_data.inventory.clear()
	
	for printer in game_data.printer:
		if printer.figure_slot:
			printer.figure_slot = false
		if printer.filament_slot:
			printer.filament_slot = false
		if printer.file:
			printer.file = false
		printer.status = "ON"
		printer.bed_temp = 0
		printer.ext_temp = 0
	is_close = false
	save_to_file()

func start_worker(id: int):
	workerThreadPool.add_task(Callable(run_printer_task).bind(id))

func _ready():
	var thread = Thread.new()
	thread.start(random_figures)
	load_from_file()

func save_to_file():
	if not FileAccess.file_exists(FILE_PATH):
		print("Error! We don't have a save to load.")
		return
	
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	file.store_line(JSON.stringify(game_data))
	print(Time.get_time_string_from_system()," - saved!")
	
func load_from_file():
	if not FileAccess.file_exists(FILE_PATH):
		print("Error! We don't have a save to load.")
		return
	
	var json_as_text = FileAccess.get_file_as_string(FILE_PATH)
	if not json_as_text:
		game_data["inventory"] = []
		game_data["hotbar"] = []
		game_data["printer"] = []
		return
	
	var json_as_dict = JSON.parse_string(json_as_text)
	game_data["inventory"] = json_as_dict.inventory
	game_data["hotbar"] = json_as_dict.hotbar
	game_data["printer"] = json_as_dict.printer
	if json_as_dict.has("user_data"):
		score = json_as_dict.user_data.score
