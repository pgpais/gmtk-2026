@tool
class_name Tile
extends Area2D

signal entity_entered_tile(entity: Entity)

@export var tile_index: int = 0
@export var highlight_color: Color = Color.YELLOW
@export var danger_color: Color = Color.RED
@export var positive_color: Color = Color.GREEN
@export var blocked_color: Color = Color.DIM_GRAY

@export var column: MapColumn

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var selectable: Selectable = $Selectable

@export var direction_ui: Control

@export var target : Sprite2D 
@export var action_cooldown: float = 8
@export var rotate_chance: float = 0.3
@export var move_chance: float = 0.5
@export var invert_chance: float = 0.6

var entity: Entity = null

var overwatches: Array[Overwatch] = []

var _base_sprite_position: Vector2
var _cooldown_timer: float = 0

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	_base_sprite_position = sprite.position

func _process(delta: float) -> void:
	_cooldown_timer -= delta
	if _cooldown_timer > 0:
		return

	_cooldown_timer = action_cooldown

	if randf() < rotate_chance:
		var direction := -1 if randf() < invert_chance else 1
		var target_rotation := sprite.rotation + direction * randf()

		var rotation_tween := create_tween()
		rotation_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		rotation_tween.tween_property(sprite, "rotation", target_rotation, action_cooldown)

	if randf() < move_chance:
		var target_position: Vector2 = (sprite.position + Vector2(randi_range(-20, 20), randi_range(-20, 20))).clamp(_base_sprite_position - Vector2(7, 7), _base_sprite_position + Vector2(7, 7))

		var position_tween := create_tween()
		position_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		position_tween.tween_property(sprite, "position", target_position, action_cooldown)

func _on_mouse_entered():
	if selectable._isSelectable:
		var tween = create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_QUAD)
		tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.15)
		tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.25)

func _on_mouse_exited():
	pass

func show_tile():
	visible = true
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func hide_tile():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(func(): visible = false)

func set_entity(entity: Entity):
	self.entity = entity
	
	if entity:
		entity_entered_tile.emit(entity)
		
		if entity.team == Entity.TEAMS.NEUTRAL and visible:
			hide_tile()
	elif ! visible:
		show_tile()

func get_entity() -> Entity:
	return entity

func trigger():
	highlight()
	show_danger_highlight()
	if entity:
		await entity.trigger()
	hide_danger_highlight()

func initialize(column: MapColumn, tile_index: int):
	self.tile_index = tile_index
	self.column = column

func _set_modulate(color: Color):
	sprite.modulate = color

func place_target():
	target.visible = true
	var orig_scale = scale

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

	var start_subtween = create_tween()
	start_subtween.set_parallel().tween_property(self, "scale", Vector2(1.4, 1.4), 0.15)

	var end_subtween = create_tween()
	end_subtween.set_parallel().tween_property(self, "scale", orig_scale, 0.25)
	
	tween.tween_subtween(start_subtween)
	tween.tween_subtween(end_subtween)
	
func hide_target():
	target.visible = false

func highlight() -> void:
	var orig_scale = scale
	var orig_modulate = modulate
	var orig_rotation = rotation_degrees

	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_QUAD)

	var start_subtween = create_tween()
	start_subtween.set_parallel().tween_property(self, "rotation_degrees", orig_rotation + 360.0, 0.4)
	start_subtween.set_parallel().tween_property(self, "scale", Vector2(1.4, 1.4), 0.15)
	start_subtween.set_parallel().tween_property(self, "modulate", Color.GOLD, 0.15)

	var end_subtween = create_tween()
	end_subtween.set_parallel().tween_property(self, "scale", orig_scale, 0.25)
	end_subtween.set_parallel().tween_property(self, "modulate", orig_modulate, 0.25)
	
	tween.tween_subtween(start_subtween)
	tween.tween_subtween(end_subtween)
	tween.tween_property(self, "rotation_degrees", orig_rotation, 0.0)

func show_danger_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, Color(1, 1, 1, 1), danger_color, 0.1)

func hide_danger_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, danger_color, Color(1, 1, 1, 1), 0.1)

func show_positive_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, Color(1, 1, 1, 1), positive_color, 0.1)

func hide_positive_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, positive_color, Color(1, 1, 1, 1), 0.1)

func show_blocked_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, Color(1, 1, 1, 1), blocked_color, 0.1)
	
func hide_blocked_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, blocked_color, Color(1, 1, 1, 1), 0.1)

func reset_highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, modulate, Color(1, 1, 1, 1), 0.1)

func select():
	EventBus.tile_selected.emit(self)

func pop_direction_buttons(toggle) -> void:
	direction_ui.visible = toggle
	
func select_direction(direction: String) -> void:
	if entity:
		entity.direction_selected.emit(direction)
		
	pop_direction_buttons(false)

func add_overwatch(overwatch: Overwatch):
	overwatches.append(overwatch)
	
func remove_overwatch(overwatch: Overwatch):
	overwatch.remove_self()
	overwatches.erase(overwatch)

func check_overwatches(entity: Entity):
	print("checking overwatches ", overwatches.size(), " on tile ", self)
	for i in range(overwatches.size()):
		var overwatch = overwatches[i]
		await overwatch.check(entity)
