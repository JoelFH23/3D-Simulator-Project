extends Node

const  MAX_SIZE: int = 10
var temp_task_list: Array = []
var task_list: Array = []
var image_list: Array = [
	"res://assets/figures/bottle.png",
	"res://assets/figures/milk.png",
	"res://assets/figures/gold_ingot.png",
]

func run_worker():
	"""create random files"""
	var id = 0
	while true:
		if task_list.size() == MAX_SIZE:
			OS.delay_msec(5000)
			continue
		task_list.append({
			"file_id": id,
			"sprite": "res://assets/file2.png",
			"status": "uncompleted"
		})
		id += 1
		OS.delay_msec(1500)

func _ready():
	var thread = Thread.new()
	thread.start(run_worker)
