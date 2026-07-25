@tool
class_name Tile
extends Selectable

@export var tile_index: int = 0
@export var highlight_color: Color = Color.YELLOW
@export var danger_color: Color = Color.RED
@export var positive_color: Color = Color.GREEN

@export var layer: MapColumn

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@export var direction_ui : Control

var entity: Entity = null

func set_entity(entity: Entity):
	self.entity = entity

func get_entity() -> Entity:
	return entity

func trigger():
	highlight()
	if entity:
		await entity.trigger()

func initialize(layer: MapColumn, tile_index: int):
	self.tile_index = tile_index
	self.layer = layer

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_method(_set_modulate, sprite.modulate, Color(1, 1, 1, 0.5), 0.1)

func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_method(_set_modulate, sprite.modulate, Color(1, 1, 1, 1), 0.1)

func _set_modulate(color: Color):
	sprite.modulate = color

func highlight() -> void:
	var tween = create_tween()
	tween.tween_method(_set_modulate, Color(1, 1, 1, 1), highlight_color, 0.1)
	tween.tween_method(_set_modulate, highlight_color, Color(1, 1, 1, 1), 0.1)

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

func pop_direction_buttons(toggle) -> void:
	direction_ui.visible = toggle
	
func select_direction(direction : String) -> void:
	if entity:
		entity.direction_selected.emit(direction)
		
	pop_direction_buttons(false)
