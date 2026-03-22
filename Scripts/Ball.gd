extends CharacterBody2D

var move_speed : int = 150
var speed_increase : float = 1.05
var angle_modifier : float = 15

signal collision_wall
signal collision_paddle

func _ready() -> void:
	randomize()
	
	# Determine a horizontal angle
	var x = 1
	if(randi_range(0, 1) == 1):
		x *= -1
	
	# Determine a vertical angle.  Prevent pure vertical
	var y = randf_range(0, 0.9)
	if(randi_range(0, 1) == 1):
		y *= -1
	
	velocity = Vector2(x, y)
	velocity *= move_speed

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var debug_string : String = "Entry Velocity: " + str(velocity)
		var collider = collision.get_collider()
		# Determine bounce angle based on collision object
		velocity = velocity.bounce(collision.get_normal())
		debug_string += "  ->  Post-Bounce Velocity: " + str(velocity)
		velocity.y = angle_modifier * (self.global_position.y - collider.global_position.y)
		debug_string += "  ->  Angle-Adjusted Velocity: " + str(velocity)
		# Speed up on paddle hits
		if collider is Node:
			if collider.is_in_group("Paddles"):
				velocity.x *= speed_increase
				debug_string += "  ->  Speed-Adjusted Velocity: " + str(velocity)
				print_debug(debug_string + "\nBall Y Position: " + str(self.global_position.y) + "  |  Paddle Y Position: " + str(collider.global_position.y))
		_handle_collision_audio(collision)

func _handle_collision_audio(collision : KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	if collider is Node:
		if collider.is_in_group("Paddles"):
			collision_paddle.emit(self)
		if collider.is_in_group("Walls"):
			collision_wall.emit(self)
