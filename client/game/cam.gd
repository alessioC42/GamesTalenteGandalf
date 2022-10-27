extends Camera2D

const SMOOTHNESS = 0.14
const ZOOM_SMOOTHNESS = 0.05
const SAFETY_MARGIN = 128 # Set to smth higher than player sprite size, extends the cameras view
const ZOOM_MIN = 0.9
const ZOOM_MAX = 10.0

onready var DEFAULTAREA : Vector2 = get_viewport_rect().size

func _process(delta):
	
	var center = (global.get_position_self_as_vec2() + global.get_position_mate_as_vec2()) / 2
	global_position = lerp(global_position, center, SMOOTHNESS)
	
	var width = global.position_self["x"] - global.position_mate["x"]
	var height = global.position_self["y"] - global.position_mate["y"]
	width = abs(width) + SAFETY_MARGIN
	height = abs(height) + SAFETY_MARGIN
	var percentage_width = width / DEFAULTAREA.x
	var percentage_height = height / DEFAULTAREA.y
	var percentage = max(percentage_height, percentage_width)
	
	percentage = clamp(percentage, ZOOM_MIN, ZOOM_MAX)
	if (percentage != 0):
		zoom.x = lerp(zoom.x, percentage, ZOOM_SMOOTHNESS)
		zoom.y = lerp(zoom.x, percentage, ZOOM_SMOOTHNESS)
