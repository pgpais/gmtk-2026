extends Control

@export var highlight_color: Color
@export var highlight_scale: Vector2


@export var animator: AnimationPlayer
@export var ticker: Ticker
@export var label: Label

func _ready():
	animator.stop()
	if ticker:
		_on_new_tick(ticker.current_count)
		ticker.new_tick.connect(_on_new_tick)
		ticker.new_cycle.connect(_on_new_tick)

func _on_new_tick(count):
	var tween = create_tween()
	var inverted_count = ticker.max_count - count
	# tween.tween_method(_change_label_scale, Vector2(1, 1), Vector2(2, 2), 0.2)
	tween.tween_method(_change_label_color, Color(1, 1, 1, 1), highlight_color, 0.2)
	tween.parallel().tween_callback(animator.play.bind("count"))
	tween.tween_callback(Callable(func(text): label.text = str(text)).bind(inverted_count))
	tween.tween_method(_change_label_color, highlight_color, Color(1, 1, 1, 1), 0.2)

func _change_label_scale(scale: Vector2):
	label.scale = scale

func _change_label_color(color: Color):
	label.self_modulate = color
