extends KinematicBody2D

onready var _global = get_node("/root/global")

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if _global.input_self[0] == "1":
		velocity.x += 1
	if _global.input_self[1] == "1":
		velocity.x -= 1
	if _global.input_self[2] == "1":
		velocity.y += 1
	if _global.input_self[3] == "1":
		velocity.y -= 1

	velocity = velocity.normalized() * _global.speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	_global.position_self = {"x": position.x, "y": position.y}
