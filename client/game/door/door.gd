extends StaticBody2D

var opened : bool = false

func _ready():
	$open.visible = false
	$closed.visible = true
	$CollisionShape2D.disabled = false

func open():
	if (opened):
		return
	opened = true
	$open.visible = true
	$closed.visible = false
	$CollisionShape2D.queue_free()
