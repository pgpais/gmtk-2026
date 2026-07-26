class_name HeartUI
extends Control

@export var fill: TextureRect
@export var fill_shadow: Sprite2D

var _state: bool = true

func _ready() -> void:
	set_state(true)

func get_state():
	return _state

func set_state(state: bool):
	fill.visible = state
	fill_shadow.visible = state
	_state = state
