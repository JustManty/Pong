extends Node

var score : Vector2i = Vector2i(0,0)
var game_logic_scene : PackedScene = preload("res://Scenes/game_logic.tscn")

signal update_score(Vector2i)

func _ready() -> void:
	_reset_game_logic()

func _on_goal_left_body_entered(body: Node2D) -> void:
	score.y += 1
	update_score.emit(score)
	_reset_game_logic()

func _on_goal_right_body_entered(body: Node2D) -> void:
	score.x += 1
	update_score.emit(score)
	_reset_game_logic()

func _reset_game_logic() -> void:
	# Delete existing Game Logic if exists
	var game_logic_node = get_node_or_null("Game Logic")
	if game_logic_node:
		game_logic_node.call_deferred("free")
	
	# Create new Game Logic instance
	var new_instance = game_logic_scene.instantiate()
	add_child(new_instance)
	
	# Reconnect score signals for UI
	var goals = new_instance.get_tree().get_nodes_in_group("Goals")
	for goal in goals:
		if goal:
			if goal.name.contains("Left"):
				goal.connect("body_entered", _on_goal_left_body_entered)
			elif goal.name.contains("Right"):
				goal.connect("body_entered", _on_goal_right_body_entered)
