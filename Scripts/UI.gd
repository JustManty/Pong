class_name GameUI
extends CanvasLayer

@onready var game: Node2D = $".."
@onready var left_score: Label = $LeftScore
@onready var right_score: Label = $RightScore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game.connect("update_score", _update_score)

func _update_score(score : Vector2i) -> void:
	left_score.text = str(score.x)
	right_score.text = str(score.y)
