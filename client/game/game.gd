extends Node2D


onready var _global = get_node("/root/global")
var player_scene = preload("res://game/player/player.tscn")
var player = player_scene.instance()
var mate = player_scene.instance()


func _ready():
	add_child(player)
	add_child(mate)


func _process(delta):
	get_input()
	set_positions()


func set_positions(): #move the player
	mate.position.x = _global.position_mate["x"]
	mate.position.y = _global.position_mate["y"]
	player.position.x = _global.position_self["x"]
	player.position.y = _global.position_self["y"]



func get_input():
	var pos = _global.position_self
	var input_happened = false
	if Input.is_action_pressed("ui_right"):
		input_happened = true
		pos.x += _global.speed
		print("hello")
	if Input.is_action_pressed("ui_left"):
		input_happened = true
		pos.x -= _global.speed
	if Input.is_action_pressed("ui_down"):
		input_happened = true
		pos.y += _global.speed
	if Input.is_action_pressed("ui_up"):
		input_happened = true
		pos.y -= _global.speed
	WebSocket._send_pos(pos.x, pos.y)
	input_happened = false
