extends Control

onready var createLobbyButton = $createLobbyButton
onready var lobbyCodeLabel = $lobbyCodeLabel
onready var lobbyEntryLabel = $lobbyEntry
onready var joinLobbyButton = $joinLobbyButton
onready var statusLabel = $statusLabel
onready var webSocketScript = get_node("/root/WebSocket")


func _on_createLobbyButton_pressed():
	webSocketScript._create_room()
	createLobbyButton.disabled = true;
	joinLobbyButton.disabled = true;
	statusLabel.text = "Waiting for an other Player to join lobby..."

func _on_joinLobbyButton_pressed():
	webSocketScript._join_room(lobbyEntryLabel.text)

func _on_lobbyEntry_focus_exited():
	lobbyEntryLabel.text = lobbyEntryLabel.text.to_upper()

