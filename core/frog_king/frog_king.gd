class_name FrogKing
extends Node2D

@export var health_component: HealthComponent
@export var animator: AnimationPlayer

func take_damage(damage: int):
	health_component.take_damage(damage)

func _ready() -> void:
	EventBus.enemy_attacked_frog_king.connect(_on_enemy_attacked_frog_king)

	health_component.health_changed.connect(_on_health_changed)
	health_component.health_depleted.connect(_die)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_frog_king_damage") && OS.has_feature("editor_runtime"):
		take_damage(1)
	pass

func _die():
	# LOSE
	print("frog king dieded")
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_interval(1)
	await tween.finished
	EventBus.game_ended.emit(false)

func _on_enemy_attacked_frog_king(enemy: Enemy):
	take_damage(enemy.frog_king_damage)

func _on_health_changed(new_health: int, old_health: int):
	print("damage taken: ")
	if old_health > new_health:
		_on_damage_taken(old_health - new_health)

func _on_damage_taken(damage: int):
	# Play animation?
	# Use damage as animation intensity?
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 0, 0), 0.1)
	tween.tween_property(self, "modulate", Color(1, 1, 1), 0.1)
	tween.set_loops(3)

func _ate_beetle():
	# WIN
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(2, 2), 0.2)
	tween.tween_interval(1)
	await tween.finished
	EventBus.game_ended.emit(true)
	pass
