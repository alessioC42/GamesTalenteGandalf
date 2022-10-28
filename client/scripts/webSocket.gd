extends Node


export var websocket_url = "ws://coxcopi.de:17339"
onready var _global = get_node("/root/global")

var _client = WebSocketClient.new()

func _ready():
	_client.connect("connection_closed", self, "_closed")
	_client.connect("connection_error", self, "_closed")
	_client.connect("connection_established", self, "_connected")
	_client.connect("data_received", self, "_on_data")

	# Initiate connection to the given URL.
	var err = _client.connect_to_url(websocket_url, ["lws-mirror-protocol"])
	
	if err != OK:
		print("Unable to connect")
		set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected to Server with protocol: ", proto)

func _send_data(data):
	#data has to be String
	_client.get_peer(1).put_packet(data.to_utf8())

func _process(_delta):
	_client.poll()

func _on_data():
	var data = JSON.parse(_client.get_peer(1).get_packet().get_string_from_utf8()).result;
	#create room
	if data.type == "roomID":
		print("created room: "+ data.ID)
		_global.roomID = data.ID
		var entry = get_tree().get_nodes_in_group("lobbyCodeLabel")
		if len(entry) >= 1:
			entry[0].text = data.ID
	elif data.type == "joined_room":
		print("Joined Room: "+data.ID)
		_global.roomID = data.ID
		_global.host = false
	elif data.type == "game_start":
		get_tree().change_scene_to(load("res://game/game.tscn"))
	elif data.type == "positions":
		_global.position_mate = data.mate
		_global.position_self = data.me
	elif data.type == "inputs":
		_global.input_mate = data.mate
		_global.input_self = data.me
	elif data.type == "error":
		var errorTextLabel = get_tree().get_nodes_in_group("errorStatusLabel")
		if len(errorTextLabel) >= 1:
			errorTextLabel[0].text = data.error
	elif data.type == "room_close":
		_global._reset_to_menue()

func _create_room():
	_send_data('{"type":"createroom"}')
	_global.host = true

func _join_room(roomID):
	_send_data('{"type":"join_room", "roomID": "'+roomID+'"}')

func _send_pos(x, y):
	_send_data('{"type":"set_position","roomID": "'+_global.roomID+'" ,"position": {"x": '+str(x)+', "y": '+str(y)+'}}')

func _send_input(inputstr):
	_send_data('{"type":"set_input","roomID": "'+_global.roomID+'" ,"input": "'+inputstr+'"}')
