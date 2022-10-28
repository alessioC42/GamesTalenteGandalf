extends Area2D

export(bool) var is_red = false
export(int) var door_index = 0

func _ready():
	if (is_red):
		$Sprite.texture = preload("res://game/map/sprites/asset_rote druckplatte oben.png")
	else:
		$Sprite.texture = preload("res://game/map/sprites/asset_blaue druckplatte oben.png")

func _on_pressureplate_body_entered(body):
	if (body.is_in_group("player") or body.is_in_group("mate")):
		if (is_red):
			if (!body.is_blue()):
				$Sprite.texture = preload("res://game/map/sprites/asset_rote druckplatte unten.png")
				global.enable_door_plate(door_index, is_red)
		else:
			if (body.is_blue()):
				$Sprite.texture = preload("res://game/map/sprites/asset_blaue druckplatte unten.png")
				global.enable_door_plate(door_index, is_red)

func _on_pressureplate_body_exited(body):
	if (body.is_in_group("player") or body.is_in_group("mate")):
		if (is_red):
			if (!body.is_blue()):
				$Sprite.texture = preload("res://game/map/sprites/asset_rote druckplatte oben.png")
				global.disable_door_plate(door_index, is_red)
		else:
			if (body.is_blue()):
				$Sprite.texture = preload("res://game/map/sprites/asset_blaue druckplatte oben.png")
				global.disable_door_plate(door_index, is_red)
