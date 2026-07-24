class_name Selectable
extends Area2D

func select():
	if (owner is Entity):
		EventBus.entity_selected.emit(owner)
	else:
		print("Selectable not owned by entity")

func _ready():
	input_event.connect(_on_input_event)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			select()
