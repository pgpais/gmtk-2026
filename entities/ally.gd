class_name Ally
extends Entity

var banked_actions: Array[ActionSequence]

func _init() -> void:
	team = TEAMS.ALLY

func set_data(data: AllyData):
	entity_data = data

	var visuals = entity_data.scene.instantiate()
	visuals.name = "Visuals"
	add_child(visuals, true)
	animator = visuals.get_node("AnimationPlayer")

func bank_actions(action_sequence: ActionSequence):
	banked_actions.append(action_sequence)

func overwatch_tiles(tiles: Array[Tile]):
	pass

func trigger():
	await act()

func act():
	for action_sequence in banked_actions:
		action_handler.perform_actions(action_sequence)

func request_move():
	EventBus.request_highlight.emit(Constants.TARGET_TYPES.TILE, entity_data.movement_range, current_tile)
	
	EventBus.tile_selected.connect(fulfill_move_request)
	EventBus.cancel_interaction.connect(cancel_move_request)

func fulfill_move_request(target_tile: Tile):
	EventBus.tile_selected.disconnect(fulfill_move_request)
	EventBus.cancel_interaction.disconnect(cancel_move_request)

	await _move_to_tile(target_tile)
	EventBus.ally_action_performed.emit()

func cancel_move_request():
	EventBus.tile_selected.disconnect(fulfill_move_request)
	EventBus.cancel_interaction.disconnect(cancel_move_request)

func request_action():
	await action_handler.perform_actions(entity_data.action_sequence)
	EventBus.ally_action_performed.emit()

func request_dismiss():
	pass
