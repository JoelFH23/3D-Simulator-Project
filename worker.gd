extends Node

const  MAX_SIZE: int = 10
var temp_task_list: Array = []
var task_list: Array = []
var image_list: Array = [
	"res://assets/file.png",
	"res://assets/bottle.png",
	"res://assets/milk.png",
	"res://assets/gold_ingot.png",
]

## status
## ok --> success
## running --> in process
## failed -->  fail for wrong temp or stopped by the user
## unclompleted --> started

func run_worker():
	"""create random items """
	var id = 0
	while true:
		if task_list.size() == MAX_SIZE:
			OS.delay_msec(5000)
			continue
		var rng = RandomNumberGenerator.new()
		task_list.append({
			"file_id": id,
			"sprite": "res://assets/file2.png",
			"pts": rng.randi_range(5, 30),
			"status": "uncompleted"
		})
		id += 1
		OS.delay_msec(1500)

func _ready():
	var thread = Thread.new()
	thread.start(run_worker)
