extends Control

@export var hearts_container: Control
@export var heart_ui_scene: PackedScene
@export var frog_king_health_component: HealthComponent

var _hearts: Array[Control]

func _ready() -> void:
	frog_king_health_component.health_changed.connect(_on_frog_king_health_changed)

	_hearts = instantiate_hearts()

func instantiate_hearts():
	var hearts: Array[Control]

	for child in hearts_container.get_children(): child.queue_free()

	for i in range(0, frog_king_health_component.max_health):
		var heart: HeartUI = heart_ui_scene.instantiate()
		hearts_container.add_child(heart, true)
		hearts.append(heart)

	return hearts

func _on_frog_king_health_changed(current_health: int, old_health: int):
	for i in range(_hearts.size()):
		_hearts[i].set_state(i < current_health)
