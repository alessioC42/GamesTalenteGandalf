extends Node2D

var player_reference = null
var is_close : bool = false
var text_index : int = 0

var text_hidden = true
onready var tween = Tween.new()

export(PoolStringArray) var texts

export(bool) var is_gandalf = false

# only used for gandalf
export(Array) var audioqueues

var player_near : bool = false

func _ready():
	text_hidden = true
	$direction.visible = false
	$interact.visible = false
	add_child(tween)
	$speechbubble/Sprite/Control/Label.text = texts[0]
	$speechbubble/AnimationPlayer.play("hide")
	
	audioqueues = audioqueues.duplicate()
	
	if (get_node_or_null("AudioStreamPlayer2D") == null):
		is_gandalf = false

func _input(event):
	if (Input.is_action_just_pressed("interact")):
		if (!is_close):
			return
		if (text_hidden):
			text_hidden = false
			$speechbubble/AnimationPlayer.play("reveal")
		if ($speechbubble/Sprite/Control/Label.percent_visible < 0.9):
			tween.stop_all()
			$speechbubble/Sprite/Control/Label.percent_visible = 1.0
			return
		if (text_index == texts.size()):
			text_index = 0
		if (is_gandalf):
			var p = get_node("AudioStreamPlayer2D") as AudioStreamPlayer2D
			p.stop()
			p.stream = audioqueues[text_index]
			p.play()
		$speechbubble/Sprite/Control/Label.percent_visible = 1.0
		$speechbubble/Sprite/Control/Label.text = texts[text_index]
		tween.interpolate_property($speechbubble/Sprite/Control/Label, "percent_visible", 0.0, 1.0, float(texts[text_index].length()) / 16.0)
		tween.start()
		text_index += 1

func _process(delta):
	if (player_reference != null):
		$direction.look_at(player_reference.global_position)

func _on_directionArea_body_entered(body):
	if (body.is_in_group("player")):
		$direction.visible = true
		player_reference = body

func _on_directionArea_body_exited(body):
	if (body.is_in_group("player")):
		$direction.visible = false

func _on_interactArea_body_entered(body):
	if (body.is_in_group("player")):
		is_close = true
		$direction.visible = false
		$interact.visible = true

func _on_interactArea_body_exited(body):
	if (body.is_in_group("player")):
		is_close = false
		$direction.visible = true
		$interact.visible = false
		if ($speechbubble/Sprite.self_modulate.a > 0.0):
			$speechbubble/AnimationPlayer.play("hide")
			text_hidden = true
