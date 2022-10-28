extends KinematicBody2D

onready var _global = get_node("/root/global")

var velocity = Vector2()

var animationSprite = null

func _ready():
	_set_color()

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
	_set_right_animation()
	get_input()
	velocity = move_and_slide(velocity)
	_local_position_correction()


func _set_right_animation():
	animationSprite.playing = true
	if "1" in _global.input_mate:
		animationSprite.animation = "walk"
		if _global.input_mate[0] == "1":
			animationSprite.flip_h = false
		elif _global.input_mate[1] == "1":
			animationSprite.flip_h = true
	else:
		animationSprite.animation = "idle"

func is_blue():
	return !_global.host

func _set_color():
	if _global.host:
		animationSprite = $redsprite
		$bluesprite.visible = false
	else:
		animationSprite = $bluesprite
		$redsprite.visible = false

func _local_position_correction():
	
	var difference = sqrt((position.x-_global.position_mate["x"])*(position.y-_global.position_mate["y"])+(position.y-_global.position_mate["y"])*(position.y-_global.position_mate["y"]))
	if difference >= 30:
		position = Vector2(_global.position_mate["x"], _global.position_mate["y"])
