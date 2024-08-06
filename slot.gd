extends PanelContainer

@onready var texture_rect = $TextureRect
@onready var quantity_label = $Label

func _get_drag_data(_at_position):
	set_drag_preview(get_preview())
	return texture_rect

func _can_drop_data(_pos, data):
	return data is TextureRect

func _drop_data(_pos, data):
	if data.texture == null:
		return
	
	print("_drop_data")
	var temp_texture = texture_rect.texture
	texture_rect.texture = data.texture
	data.texture = temp_texture
	
	var temp_label = data.get_parent().get_children()[1].text
	data.get_parent().get_children()[1].text = quantity_label.text
	quantity_label.text = temp_label

func get_preview():
	var preview_texture = TextureRect.new()
	preview_texture.texture = texture_rect.texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
	return preview

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
