extends CharacterBody2D

@export_range(1, 2) var player : int
@export var use_ai : bool = false

@onready var ball: CharacterBody2D = $"../Ball"
@onready var paddle_up_action_name : String = "p" + str(player) + "_paddle_up"
@onready var paddle_down_action_name : String = "p" + str(player) + "_paddle_down"

var move_speed : int = 250
var maximum_allowed_distance_from_ball : int = 10

func _physics_process(delta: float) -> void:
	if(use_ai == false):
		# Handle Vertical Movement:
		if Input.is_action_pressed(paddle_up_action_name):
			# Set Upward Movement
			velocity = Vector2(0, -1 * move_speed)
		elif Input.is_action_pressed(paddle_down_action_name):
			# Set Downward Movement
			velocity = Vector2(0, move_speed)
		else:
			# Eliminate Movement
			velocity = Vector2.ZERO
	else:
		# Handle Vertical Movement:
		if ball.position.y < position.y and abs(ball.position.y - position.y) > maximum_allowed_distance_from_ball:
			# Set Upward Movement
			velocity = Vector2(0, -1 * move_speed)
		elif ball.position.y > position.y and abs(ball.position.y - position.y) > maximum_allowed_distance_from_ball:
			# Set Downward Movement
			velocity = Vector2(0, move_speed)
		else:
			# Eliminate Movement
			velocity = Vector2.ZERO
	
	move_and_slide()
