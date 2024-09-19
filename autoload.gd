extends Node

var mutex = Mutex.new()
var hotbar_list: Array[Dictionary]
var inventory_list: Array[Dictionary]
const FILE_PATH = "res://game_data.json"
var workerThreadPool = WorkerThreadPool
var game_data: Dictionary = {"inventory":[],"hotbar":[],"printer":[]}
var errors_list: Array
var printer_info_list: Array

func worker(printer_id: int):
	var i = 0
	while i != 10:
		if not int(game_data.printer[printer_id].quantity):
			print("AN ERROR OCCURRED")
			errors_list.append(printer_id)
			break
		game_data.printer[printer_id].quantity -= 1
		for idx in printer_info_list.size():
			if int(printer_info_list[idx].id) == int(printer_id):
				print("bed_temp: ", printer_info_list[idx].bed_temp)
				print("ext_temp: ", printer_info_list[idx].ext_temp)
		OS.delay_msec(400)
		i += 1
	mutex.lock()
	save_to_file()
	mutex.unlock()

func start_worker(id: int):
	workerThreadPool.add_task(Callable(worker).bind(id))

func _ready():
	load_from_file()

func save_to_file():
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
