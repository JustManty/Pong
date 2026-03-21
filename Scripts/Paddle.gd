extends CharacterBody2D

@export_range(1, 2) var player : int
@export var use_ai : bool = false

@onready var ball: CharacterBody2D = $"../Ball"

var move_speed : int = 250
var maximum_allowed_distance_from_ball : int = 10

func _physics_process(delta: float) -> void:
	if(not use_ai):
		# Handle Vertical Movement:
		if Input.is_action_pressed("p" + str(player) + "_paddle_up"):
			# Set Upward Movement
			velocity = Vector2(0, -1 * move_speed)
		elif Input.is_action_pressed("p" + str(player) + "_paddle_down"):
			# Set Downward Movement
			velocity = Vector2(0, move_speed)
		else:
			# Eliminate Movement
			velocity /= 10
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
			velocity /= 50
	
	move_and_slide()
