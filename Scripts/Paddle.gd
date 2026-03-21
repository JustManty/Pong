extends CharacterBody2D

@export_range(0, 2) var player : int
@export var use_ai : bool = false

@onready var ball: CharacterBody2D = $"../Ball"

var move_speed : int = 250

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
			velocity = Vector2.ZERO
	else:
		# Handle Vertical Movement:
		if ball.position.y < position.y:
			# Set Upward Movement
			velocity = Vector2(0, -1 * move_speed)
		elif ball.position.y > position.y:
			# Set Downward Movement
			velocity = Vector2(0, move_speed)
		else:
			# Eliminate Movement
			velocity = Vector2.ZERO
	
	move_and_slide()
