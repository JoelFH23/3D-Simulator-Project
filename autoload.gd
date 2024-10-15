extends Node

var mutex = Mutex.new()
var hotbar_list: Array[Dictionary]
var inventory_list: Array[Dictionary]
var workerThreadPool = WorkerThreadPool
var game_data: Dictionary = {"inventory":[],"hotbar":[],"printer":[]}
var errors_list: Array
var printer_info_list: Array = []
var score = 0
const FILE_PATH = "res://data//game_data.json"

func _remove_elements():
	for idx in game_data.printer.size():
		game_data.printer[idx].file = false
		
	for idx in game_data.hotbar.size():
		game_data.hotbar[idx].file = false
	
	save_to_file()

func _notification(what):
	"""save game when app is closed"""
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		print("removing files...")
		#_remove_elements()
		print("ready...")
		#OS.delay_msec(40)
		#get_tree().quit()

func worker(printer_id: int):
	"""
	var block_size = 0
	var total = 100
	while block_size < total:
		var rng = RandomNumberGenerator.new()
		block_size += rng.randi_range(1, 5)
		var percent = (block_size / total) * 100
		print("percent: ",percent)
		print("block_size: ", block_size)
		OS.delay_msec(20)
	"""
	var i = 0
	while i != 10:
		if not int(game_data.printer[printer_id].quantity):
			print("AN ERROR OCCURRED")
			errors_list.append(printer_id)
			break
		game_data.printer[printer_id].quantity -= 1
		
		for idx in game_data.printer.size():
			if int(game_data.printer[idx].idx) == int(printer_id):
				if game_data.printer[idx].figure.status == "FAIL":
					return
				game_data.printer[idx].figure.status = "running..."
		OS.delay_msec(100)
		i += 1
	
	mutex.lock()
	for idx in game_data.printer.size():
		if int(game_data.printer[idx].idx) == int(printer_id):
			game_data.printer[idx].figure.status = "FINISH"
	save_to_file()
	mutex.unlock()

func start_worker(id: int):
	workerThreadPool.add_task(Callable(worker).bind(id))

func _ready():
	#_remove_elements()
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
