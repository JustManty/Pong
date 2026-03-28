extends Node2D

var score : Vector2i = Vector2i(0,0)
var game_logic_scene : PackedScene = preload("res://Scenes/game_logic.tscn")
var game_menu_scene : PackedScene = preload("res://Scenes/Menu.tscn")
var _is_resetting : bool = false
var _game_started : bool = false

signal update_score(Vector2i)

func _process(_delta: float) -> void:
	if _game_started:
		if Input.is_action_just_pressed("ui_menu"):
			var game_logic = get_node_or_null("Game Logic") as Node2D
			var game_ui = get_node_or_null("UI") as CanvasLayer
			if get_tree().paused:
				var menu = get_node_or_null("Menu") as MenuUI
				menu.queue_free()
				await menu.tree_exited
				if game_logic:
					game_logic.visible = true
				if game_ui:
					game_ui.visible = true
				get_tree().paused = false
			else:
				if game_logic:
					game_logic.visible = false
				if game_ui:
					game_logic.visible = false
				var menu = game_menu_scene.instantiate()
				menu.set_state(_game_started)
				add_child(menu)
				if not menu.game_reset.is_connected(_on_new_game):
					menu.game_reset.connect(_on_new_game)
				if not menu.game_resumed.is_connected(_on_resume_game):
					menu.game_resumed.connect(_on_resume_game)
				get_tree().paused = true

func _on_new_game() -> void:
	var menu = get_node_or_null("Menu") as MenuUI
	var ui = get_node_or_null("UI") as GameUI
	menu.queue_free()
	await menu.tree_exited
	ui.visible = true
	score = Vector2.ZERO
	update_score.emit(score)
	get_tree().paused = false
	_reset_game_logic()

func _on_resume_game() -> void:
	var game_logic = get_node_or_null("Game Logic") as Node2D
	var game_ui = get_node_or_null("UI") as CanvasLayer
	var menu = get_node_or_null("Menu") as MenuUI
	menu.queue_free()
	await menu.tree_exited
	if game_logic:
		game_logic.visible = true
	if game_ui:
		game_ui.visible = true
	get_tree().paused = false

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
	
	_game_started = true
