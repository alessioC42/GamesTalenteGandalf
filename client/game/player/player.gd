extends KinematicBody2D

onready var _global = get_node("/root/global")

var velocity = Vector2()

var animationSprite = null

func _ready():
	_set_color()

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
	_set_right_animation()
	WebSocket._send_pos(position.x, position.y)

func _set_right_animation():
	animationSprite.playing = true
	if "1" in _global.input_self:
		animationSprite.animation = "walk"
		if _global.input_self[0] == "1":
			animationSprite.flip_h = false
		elif _global.input_self[1] == "1":
			animationSprite.flip_h = true
	else:
		animationSprite.animation = "idle"

func is_blue():
	return _global.host

func _set_color():
	if _global.host:
		animationSprite = $bluesprite
		$redsprite.visible = false
	else:
		animationSprite = $redsprite
		$bluesprite.visible = false
