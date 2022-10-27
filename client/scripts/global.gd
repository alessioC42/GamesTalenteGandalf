extends Node

var position_mate = {"x": 0, "y": 0}
var position_self = {"x": 0, "y": 0}
var input_self = "0000"
var input_mate = "0000"
var host = false
var roomID = ""
var speed = 300

func get_position_self_as_vec2():
	var player = get_tree().get_nodes_in_group("player")[0]
	return Vector2(player.position.x, player.position.y)

func get_position_mate_as_vec2():
	var mate = get_tree().get_nodes_in_group("mate")[0]
	return Vector2(mate.position.x, mate.position.y)
