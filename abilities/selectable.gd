class_name Selectable
extends Area2D

signal can_be_selected(state: bool)
signal selected
signal hovered(state: bool)

@export var _isSelectable = false
var _isHovered = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	input_event.connect(_on_input_event)

func _on_mouse_entered():
	_isHovered = true
	hovered.emit(_isHovered)

func _on_mouse_exited():
	_isHovered = false
	hovered.emit(_isHovered)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed && _isHovered:
			select()

func select():
	if (!_isSelectable):
		return

	if (owner is Entity):
		EventBus.entity_selected.emit(owner)
	elif (owner is Tile):
		EventBus.tile_selected.emit(owner)
	else:
		print("Selectable not owned by entity")
	
	selected.emit()

func set_selectable(state: bool):
	_isSelectable = state
	can_be_selected.emit(state)
