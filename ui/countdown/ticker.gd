class_name Ticker
extends Node

signal new_cycle(count)
signal new_tick(count)

@export var game_settings: GameSettings

@onready var max_count: int = game_settings.map_columns
var current_count: int = 0

func _ready() -> void:
	EventBus.ally_action_performed.connect(next_tick)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("move_ticker") && OS.has_feature("editor_runtime"):
		next_tick()

func next_tick():
	current_count = current_count + 1

	if current_count == max_count:
		reset()
		EventBus.tick_triggers_finished.emit()
	else:
		EventBus.ticker_new_tick.emit(current_count)
		new_tick.emit(current_count)

	print("current tick: ", current_count)

func reset():
	current_count = -1
	EventBus.new_cycle.emit()
	new_cycle.emit(current_count)
	
	print("new cycle")
