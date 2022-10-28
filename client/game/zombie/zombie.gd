extends KinematicBody2D

export(float) var speed = 1
onready var _global = get_node("/root/global")
var direction = "down"
var velocity = Vector2()

func set_direction():
	velocity = Vector2()

	if direction == "down":
		velocity.y += 1
	elif direction == "up":
		velocity.y -= 1
	
	velocity = velocity.normalized() * speed

func _physics_process(delta):
	set_direction()
	var colisioninfo = move_and_collide(velocity)
	if colisioninfo:
		if (colisioninfo.collider.name == "collisionMap"):
			_turn()

func _turn():
	if (direction == "down"):
		direction = "up"
	elif (direction == "up"):
		direction = "down"


func _on_Area2D_body_entered(body):
	if (body.get_name() in ["player", "mate"]):
		_global._reset_to_menue()
