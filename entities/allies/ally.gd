class_name Ally
extends Entity

var banked_actions: Array[ActionSequence]
var used_this_cycle : bool = false

var currently_hidden : bool = false

@export var entity_ui : Control

func _ready() -> void:
	super._ready()	
	EventBus.new_cycle.connect(reset_usage)

func set_data(data: AllyData, start_hidden = false):
	entity_data = data

	var visuals = entity_data.scene.instantiate()
	visuals.name = "Visuals"
	add_child(visuals, true)
	animator = visuals.get_node("AnimationPlayer")
	
	currently_hidden = start_hidden
	
	if start_hidden:
		play_animation("bubbles")
	else:
		play_animation("spawn")

func bank_actions(action_sequence: ActionSequence):
	banked_actions.append(action_sequence)

func overwatch_tiles(tiles: Array[Tile]):
	pass

func die():
	if ! currently_hidden:
		play_animation("dismiss")
	queue_free()

func trigger():
	for action_sequence in banked_actions:
		await action_handler.perform_actions(action_sequence)

func activate(player_action : bool = false):
	play_animation("under", true)
	
	if currently_hidden:
		currently_hidden = false
		
	team = TEAMS.ALLY
	
	EventBus.ally_action_performed.emit()

func dive(player_action : bool = false):
	play_animation("under")
	
	team = TEAMS.NEUTRAL
	
	if player_action:
		EventBus.ally_action_performed.emit()

func dismiss(player_action : bool = false):
	play_animation("dismiss")
	
	if player_action:
		EventBus.ally_action_performed.emit()
		
	queue_free()

func request_move():
	EventBus.request_highlight.emit(Constants.TARGET_TYPES.TILE, entity_data.movement_range, current_tile, Entity.TEAMS.ALLY, true)

	EventBus.tile_selected.connect(fulfill_move_request)
	EventBus.cancel_interaction.connect(cancel_move_request)

func fulfill_move_request(target_tile: Tile):
	EventBus.tile_selected.disconnect(fulfill_move_request)
	EventBus.cancel_interaction.disconnect(cancel_move_request)

	await _move_to_tile(target_tile)
	
	used_this_cycle = true
	EventBus.ally_action_performed.emit()

func cancel_move_request():
	EventBus.tile_selected.disconnect(fulfill_move_request)
	EventBus.cancel_interaction.disconnect(cancel_move_request)

func request_action():
	await action_handler.perform_actions(entity_data.action_sequence)
	used_this_cycle = true
	EventBus.ally_action_performed.emit()

func reset_usage():
	used_this_cycle = false
