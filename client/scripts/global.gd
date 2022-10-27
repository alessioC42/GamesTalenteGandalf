extends Node

var position_mate = {"x": 300, "y": 300}
var position_self = {"x": 500, "y": 500}
var host = false
var roomID = ""
var speed = 10

func get_position_self_as_vec2():
	return Vector2(position_self["x"], position_self["y"])

func get_position_mate_as_vec2():
	return Vector2(position_mate["x"], position_mate["y"])
