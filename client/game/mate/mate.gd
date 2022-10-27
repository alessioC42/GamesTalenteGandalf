extends KinematicBody2D

onready var _global = get_node("/root/global")

var velocity = Vector2()

func get_input():
	velocity = Vector2()
	if _global.input_mate[0] == "1":
		velocity.x += 1
	if _global.input_mate[1] == "1":
		velocity.x -= 1
	if _global.input_mate[2] == "1":
		velocity.y += 1
	if _global.input_mate[3] == "1":
		velocity.y -= 1
	velocity = velocity.normalized() * _global.speed

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity)
	_global.position_mate = {"x": position.x, "y": position.y}
