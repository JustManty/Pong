extends Node

var score : Vector2i = Vector2i(0,0)

signal update_score(Vector2i)

func _on_goal_left_body_entered(body: Node2D) -> void:
	score.y += 1
	update_score.emit(score)

func _on_goal_right_body_entered(body: Node2D) -> void:
	score.x += 1
	update_score.emit(score)
