extends Control

@export var frog_king: FrogKing

@export var health_bar: ProgressBar

@onready var health_component: HealthComponent = frog_king.health_component

func _ready() -> void:
	health_bar.max_value = health_component.max_health
	health_bar.value = health_component.current_health

	health_component.health_changed.connect(on_health_changed)
	health_component.health_depleted.connect(on_health_depleted)

func on_health_changed(new_health: int, old_health: int):
	health_bar.value = new_health

func on_health_depleted():
	pass
