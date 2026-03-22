extends CharacterBody2D

var move_speed : int = 150
var speed_increase : float = 1.05
var angle_impact : float = 10

signal collision_wall
signal collision_paddle

func _physics_process(delta: float) -> void:
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider()
		if collider is Node:
			_calculate_bounce_angle(collider)
		_handle_collision_audio(collision)

func _handle_collision_audio(collision : KinematicCollision2D) -> void:
	var collider = collision.get_collider()
	if collider is Node:
		if collider.is_in_group("Paddles"):
			collision_paddle.emit(self)
		if collider.is_in_group("Walls"):
			collision_wall.emit(self)

func _calculate_bounce_angle(collision_node : Node) -> void:
	if collision_node.is_in_group("Walls"):
		velocity.y *= -1
	elif collision_node.is_in_group("Paddles"):
		var max_distance : float = abs(collision_node.get_center() - collision_node.get_bottom_edge())
		var actual_distance : float = abs(self.global_position.y - collision_node.get_center())
		var actual_impact : float = (actual_distance / max_distance) * angle_impact
		if collision_node.get_center() < self.global_position.y:
			velocity.y += actual_impact
		else:
			velocity.y -= actual_impact
		velocity.x *= -1
	pass

func _create_initial_velocity() -> void:
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
	

func _on_initial_timer_timeout() -> void:
	_create_initial_velocity()
