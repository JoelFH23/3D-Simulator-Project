extends Node

var inventory_list: Array[Dictionary]
var hotbar_list: Array[Dictionary]
const FILE_PATH = "res://game_data.json"
var workerThreadPool = WorkerThreadPool
var game_data: Dictionary = {"inventory":[],"hotbar":[],"printer":[]}

func worker(id):
	var i = 0
	while i != 10:
		print("current printer: ",game_data.printer)
		OS.delay_msec(800)
		i += 1

func start_worker(id: String):
	workerThreadPool.add_task(Callable(worker).bind(id))

func _ready():
	#var task_id = WorkerThreadPool.add_group_task(process_enemy_ai, enemies.size())
	#print("task_id: ",task_id)
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
