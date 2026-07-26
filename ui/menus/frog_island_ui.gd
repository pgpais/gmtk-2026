extends Control

@export var threshold: int = 20
@export var move_duration_min: float = 3
@export var move_duration_max: float = 10

var _base_position: Vector2

func _ready():
	_base_position = position
	_wander()

func _wander():
	var target := _base_position + Vector2(randf_range(-threshold, threshold), randf_range(-threshold, threshold))
	var duration := randf_range(move_duration_min, move_duration_max)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", target, duration)
	tween.finished.connect(_wander)
