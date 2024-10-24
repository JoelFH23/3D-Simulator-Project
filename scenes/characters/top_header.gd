extends MarginContainer
@onready var ScoreLabel = $ScoreLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	ScoreLabel.text = "SCORE: " + str(Autoload.score)
