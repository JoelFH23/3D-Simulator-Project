extends TextureRect

func _get_drag_data(_at_position):
	print("_get_drag_data")
	var preview_texture = TextureRect.new()
 
	preview_texture.texture = texture
	preview_texture.expand_mode = 1
	preview_texture.size = Vector2(30,30)
 
	var preview = Control.new()
	preview.add_child(preview_texture)
 
	set_drag_preview(preview)
	texture = null
 
	return preview_texture.texture
 
func _can_drop_data(pos, data):
	print("_can_drop_data", pos, data)
	return data is Texture2D

func _drop_data(_pos, data):
	print("_drop_data")
	texture = data

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
