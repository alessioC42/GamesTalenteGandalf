extends Node2D

onready var _global = get_node("/root/global")
var player_scene = preload("res://game/player/player.tscn")
var mate_scene = preload("res://game/mate/mate.tscn")
var player = player_scene.instance()
var mate = mate_scene.instance()

func _ready():
	add_child(player)
	add_child(mate)
	if _global.host:
		player.position.x = -1070
		player.position.y = 20
		mate.position.x = -1070
		mate.position.y = 70
	else:
		player.position.x = -1070
		player.position.y = 70
		mate.position.x = -1070
		mate.position.y = 20
		
func _process(delta):
	send_input()

func send_input():
	var pos = _global.position_self
	var input = "0000"

	if Input.is_action_pressed("ui_right"):
		input[0] = "1"
		pos.x += _global.speed
	if Input.is_action_pressed("ui_left"):
		input[1] = "1"
		pos.x -= _global.speed
	if Input.is_action_pressed("ui_down"):
		input[2] = "1"
		pos.y += _global.speed
	if Input.is_action_pressed("ui_up"):
		input[3] = "1"
		pos.y -= _global.speed
	WebSocket._send_input(input)
