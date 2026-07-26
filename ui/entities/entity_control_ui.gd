extends Control

@export var move_button: Button

@export var action_button: Button

@export var dismiss_button: Button

@export var h_box : HBoxContainer

var is_visible: bool = false

var ally: Ally

func _ready():
	ally = owner as Ally
	# ally._selectable.selected.connect(trigger_show)
	ally._selectable.can_be_selected.connect(_on_can_be_selected)

	EventBus.entity_selected.connect(_on_entity_selected)
	EventBus.ally_selected.connect(_on_ally_selected)

	trigger_hide()

	move_button.pressed.connect(_on_move_button_pressed)
	action_button.pressed.connect(_on_action_button_pressed)
	dismiss_button.pressed.connect(_on_dismiss_button_pressed)	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_key_pressed(Key.KEY_ESCAPE):
		trigger_hide()

func _on_move_button_pressed():
	ally.request_move()

func _on_action_button_pressed():
	ally.request_action()
	
func _on_dismiss_button_pressed():
	ally.dismiss(true)

func _on_entity_selected(entity: Entity):
	if entity != owner:
		trigger_hide()

func _on_ally_selected(entity: Entity):
	if ! ally.entity_data.action_sequence or ally.entity_data.action_sequence.actions.is_empty():
		action_button.visible = false
	
	if entity == owner:
		move_button.disabled = false
		action_button.disabled = false
		dismiss_button.disabled = false
		
		if entity.banked_actions.is_empty():
			action_button.disabled = false
		trigger_show()

func trigger_show():
	is_visible = true

	show()
	
	h_box.pivot_offset = h_box.size / 2
	h_box.scale = Vector2(0.1, 0.1) 
	
	var tween = create_tween()
	tween.set_parallel(true)
	
	tween.tween_property(h_box, "scale", Vector2(1, 1), 0.2) \
		.set_trans(Tween.TRANS_BACK) \
		.set_ease(Tween.EASE_OUT)
		
	var target_position = global_position + Vector2(0, 20) 
	
	tween.tween_property(h_box, "global_position", target_position, 0.2) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_OUT)

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
