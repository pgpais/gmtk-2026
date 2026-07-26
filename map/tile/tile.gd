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

var base_sprite_position;
var entity: Entity = null

var overwatches: Array[Overwatch] = []

@export var target : Sprite2D 

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	base_sprite_position = sprite.position

func _process(delta: float) -> void:
	sprite.rotation += randf() * delta
	sprite.position = (sprite.position + Vector2(randi_range(-20, 20), randi_range(-20, 20)) * delta).clamp(base_sprite_position - Vector2(10, 10), base_sprite_position + Vector2(10, 10))

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
