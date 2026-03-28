extends Node

var score : Vector2i = Vector2i(0,0)
var game_logic_scene : PackedScene = preload("res://Scenes/game_logic.tscn")
var _is_resetting : bool = false

signal update_score(Vector2i)

func _ready() -> void:
	_reset_game_logic()

func _on_goal_left_body_entered(_body: Node2D) -> void:
	if _is_resetting:
		return
		
	if(_body is Ball):
		_is_resetting = true
		_body.queue_free()
		score.y += 1
		update_score.emit(score)
		call_deferred("_reset_game_logic")

func _on_goal_right_body_entered(_body: Node2D) -> void:
	if _is_resetting:
		return
		
	if(_body is Ball):
		_is_resetting = true
		_body.queue_free()
		score.x += 1
		update_score.emit(score)
		call_deferred("_reset_game_logic")

func _reset_game_logic() -> void:
	# Delete existing Game Logic if exists
	var game_logic_node = get_node_or_null("Game Logic")
	if game_logic_node:
		game_logic_node.queue_free()
		await game_logic_node.tree_exited
	
	# Create new Game Logic instance
	var new_instance = game_logic_scene.instantiate()
	add_child(new_instance)
	
	_is_resetting = false
	
	# Reconnect score signals for UI
	var goals = []
	for node in get_tree().get_nodes_in_group("Goals"):
		if new_instance.is_ancestor_of(node):
			goals.append(node)
		
	for goal in goals:
		if goal:
			if goal.name.contains("Left"):
				if not goal.body_entered.is_connected(_on_goal_left_body_entered):
					goal.body_entered.connect(_on_goal_left_body_entered, CONNECT_ONE_SHOT)
			elif goal.name.contains("Right"):
				if not goal.body_entered.is_connected(_on_goal_right_body_entered):
					goal.body_entered.connect(_on_goal_right_body_entered, CONNECT_ONE_SHOT)
