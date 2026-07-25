extends Control

@export var move_button: Button
@export var move_reference: Control

@export var action_button: Button
@export var action_reference: Control

@export var dismiss_button: Button
@export var dismiss_reference: Control

var is_visible: bool = false

var ally: Ally

func _ready():
	ally = owner as Ally
	# ally._selectable.selected.connect(trigger_show)
	ally._selectable.can_be_selected.connect(_on_can_be_selected)

	EventBus.entity_selected.connect(_on_entity_selected)

	trigger_hide()


	move_button.pressed.connect(_on_move_button_pressed)
	action_button.pressed.connect(_on_action_button_pressed)
	dismiss_button.pressed.connect(trigger_hide)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(Key.KEY_ESCAPE):
		trigger_hide()

func _on_move_button_pressed():
	ally.request_move()

func _on_action_button_pressed():
	pass
		
func _on_entity_selected(entity: Entity):
	if entity == owner:
		trigger_show()
	else:
		trigger_hide()

func trigger_show():
	is_visible = true
	move_button.disabled = false
	action_button.disabled = false
	dismiss_button.disabled = false

	show()
	var tween = create_tween()

	var move_subtween = create_tween()
	tween.set_parallel().tween_subtween(move_subtween)
	move_subtween.tween_property(move_button, "global_position", move_reference.global_position, 0.1)

	var action_subtween = create_tween()
	tween.set_parallel().tween_subtween(action_subtween)
	action_subtween.tween_property(action_button, "global_position", action_reference.global_position, 0.1)

	var dismiss_subtween = create_tween()
	tween.set_parallel().tween_subtween(dismiss_subtween)
	dismiss_subtween.tween_property(dismiss_button, "global_position", dismiss_reference.global_position, 0.1)

func trigger_hide():
	is_visible = false
	move_button.disabled = true
	action_button.disabled = true

	var tween = create_tween()

	var move_subtween = create_tween()
	tween.set_parallel().tween_subtween(move_subtween)
	move_subtween.tween_property(move_button, "position", Vector2(0, 0), 0.1)

	var action_subtween = create_tween()
	tween.set_parallel().tween_subtween(action_subtween)
	action_subtween.tween_property(action_button, "position", Vector2(0, 0), 0.1)

	var dismiss_subtween = create_tween()
	tween.set_parallel().tween_subtween(dismiss_subtween)
	dismiss_subtween.tween_property(dismiss_button, "position", Vector2(0, 0), 0.1)

	tween.tween_callback(hide)

func _on_can_be_selected(can_be_selected: bool):
	print("can be selected: ", can_be_selected)
	if !can_be_selected:
		trigger_hide()
