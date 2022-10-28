extends Area2D

onready var _global = get_node("/root/global")


func _on_Area2D_body_entered(body):
	_global._gamewin()
