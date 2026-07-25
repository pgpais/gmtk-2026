class_name Selectable
extends Area2D

var _selectable = false

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			select()

func select():
	# if (owner is Entity):
	# 	EventBus.entity_selected.emit(owner)
	# elif (owner is Tile):
	EventBus.tile_selected.emit(owner)
	# else:
	# 	print("Selectable not owned by entity")

func set_selectable(state: bool):
	_selectable = state