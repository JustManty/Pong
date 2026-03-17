extends CharacterBody2D

@export var move_speed : int = 5
var height : int
var mid_height : int

func _ready() -> void:
	height = $Sprite2D.get_rect().size.y
	mid_height = height / 2

func _process(delta: float) -> void:
	if Input.is_action_pressed("p1_paddle_up"):
		move_up()
		pass
	elif Input.is_action_pressed("p1_paddle_down"):
		move_down()
		pass

func move_up():
	if position.y > mid_height:
		position.y -= min(position.y - mid_height, move_speed)
	else:
		position.y = mid_height
	
func move_down():
	if position.y < mid_height:
		position.y += min(position.y - mid_height + get_viewport_rect().size.y, move_speed)
	else:
		position.y = mid_height
