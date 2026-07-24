class_name HealthComponent
extends Node

signal health_changed(new_health: int, old_health: int)
signal health_depleted

@export var max_health: int = 100

@onready var current_health: int = max_health

func heal(damage: int):
	var old_health = current_health
	current_health += damage

	health_changed.emit(current_health, old_health)

func take_damage(damage: int):
	var old_health = current_health
	current_health -= damage

	health_changed.emit(current_health, old_health)

func reset():
	current_health = max_health

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	reset()