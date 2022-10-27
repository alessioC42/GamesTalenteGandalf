extends Node

var position_mate = {"x": 0, "y": 0}
var position_self = {"x": 0, "y": 0}
var input_self = "0000"
var input_mate = "0000"
var host = false
var roomID = ""
var speed = 300


func get_position_self_as_vec2():
	return Vector2(position_self["x"], position_self["y"])

func get_position_mate_as_vec2():
	return Vector2(position_mate["x"], position_mate["y"])
