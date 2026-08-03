@tool
extends Control
@export var flip: bool = true:
	set(value):
		flip = value
		_update_speed_visuals()

func _ready() -> void:
	_update_speed_visuals()

func _update_speed_visuals():
	$TextureRect.flip_h = not flip
