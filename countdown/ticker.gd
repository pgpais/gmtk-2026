class_name Ticker
extends Node

signal new_tick(count)

@export var game_settings: GameSettings

@onready var max_count: int = game_settings.map_columns
var current_count: int = 0

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_ticker") && OS.has_feature("editor_runtime"):
		next_tick()

func next_tick():
	new_tick.emit(current_count)
	EventBus.ticker_new_tick.emit(current_count)
	print("current tick: ", current_count)

	if current_count + 1 == max_count:
		reset()
	else:
		current_count += 1

func reset():
	current_count = 0
	EventBus.new_cycle.emit()
	
	print("new cycle")
