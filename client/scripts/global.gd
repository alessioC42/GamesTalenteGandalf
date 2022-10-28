extends Node

var position_mate = {"x": 0, "y": 0}
var position_self = {"x": 0, "y": 0}
var input_self = "0000"
var input_mate = "0000"
var host = false
var roomID = ""
var speed = 200


func get_position_self_as_vec2():
	return get_tree().get_nodes_in_group("player")[0].position
 
func get_position_mate_as_vec2():
	return get_tree().get_nodes_in_group("mate")[0].position

func _process(_delta):
	#print(str(position_self) + str(position_mate))
	pass

func _reset_to_menue():
	get_tree().change_scene_to(load("res://menue/mainmenue.tscn"))
	host = false
	input_self = "0000"
	input_mate = "0000"
	roomID = ""
	speed = 200
	position_mate = {"x": 0, "y": 0}
	position_self = {"x": 0, "y": 0}
	WebSocket._client.disconnect_from_host()
	WebSocket._client.connect_to_url(WebSocket.websocket_url, ["lws-mirror-protocol"])
