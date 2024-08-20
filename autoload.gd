extends Node

var inventory_list: Array = []
var hotbar_list: Array = []
const FILE_PATH = "res://savegame.save"

func _ready():
	load_from_file()

func save_to_file():
	var file = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	
	# Check if the file exists
	if FileAccess.file_exists(FILE_PATH):
		print("File already exists. Overwriting...")
	else:
		print("File does not exist. Creating a new file...")
	
	var inventory_items = []
	for inventory_slot in Autoload.inventory_list:
		if inventory_slot.sprite:
			inventory_items.append({
				"sprite": inventory_slot.sprite.resource_path,
				"quantity": inventory_slot.quantity
			})
		else:
			inventory_items.append({
				"sprite": false,
			})
	
	var hotbar_items = []
	for hotbar_slot in Autoload.hotbar_list:
		if hotbar_slot.sprite:
			hotbar_items.append({
				"sprite": hotbar_slot.sprite.resource_path,
				"quantity": hotbar_slot.quantity
			})
		else:
			hotbar_items.append({
				"sprite": false,
			})
	
	var inventory_items_string = JSON.stringify(inventory_items)
	var hotbar_items_string = JSON.stringify(hotbar_items)
	file.store_line(inventory_items_string)
	file.store_line(hotbar_items_string)
	print(Time.get_time_string_from_system()," - saved!")

func load_from_file():
	if not FileAccess.file_exists(FILE_PATH):
		print("Error! We don't have a save to load.")
		return
	
	var file = FileAccess.open(FILE_PATH, FileAccess.READ)
	var json1 = JSON.new()
	var json2 = JSON.new()
	
	var inventory_items_string = file.get_line()
	var hotbar_items_string = file.get_line()
	
	var error = json1.parse(inventory_items_string)
	var error2 = json2.parse(hotbar_items_string)
	
	if !error or !error2:
		var inventory_slots = json1.data
		for item in inventory_slots:
			if item.sprite:
				Autoload.inventory_list.append({
					"sprite": load(item.sprite),
					"quantity": item.quantity
				})
			else:
				Autoload.inventory_list.append({
					"sprite": false
				})
		
		var hotbar_slots: Array = json2.data
		for idx in hotbar_slots.size():
			if hotbar_slots[idx].sprite:
				Autoload.hotbar_list.append({
					"idx": str(idx),
					"sprite": load(hotbar_slots[idx].sprite),
					"quantity": hotbar_slots[idx].quantity
				})
			else:
				Autoload.hotbar_list.append({
					"idx": str(idx),
					"sprite": false
				})
