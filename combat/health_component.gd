class_name HealthComponent
extends Node
signal health_changed(new_health: int, old_health: int)

@export var max_health: int = 100

var current_health: int

func heal(damage: int):
	current_health += damage

	health_changed.emit(current_health, current_health)

func take_damage(damage: int):
	current_health -= damage

	health_changed.emit(current_health, current_health)

func reset():
	current_health = max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()