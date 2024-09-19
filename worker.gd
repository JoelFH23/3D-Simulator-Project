extends Node

const  MAX_SIZE: int = 9
var id: int = 0
var is_running: bool = false
var task_list: Array = []
var image_list: Array = [
	"res://assets/bottle.png",
	"res://assets/brick.png",
	"res://assets/gold_ingot.png",
]

func run_worker():
	while true:
		#print("New item created! ", Time.get_datetime_string_from_system())
		if task_list.size() == MAX_SIZE:
			continue
		print(id," - item added")
		task_list.append({
			"id": id,
			"sprite": image_list.pick_random()
		})
		id += 1
		OS.delay_msec(1000)

func _ready():
	var thread = Thread.new()
	thread.start(run_worker)
