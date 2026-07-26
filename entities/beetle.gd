extends Entity

func trigger():
	if current_tile.column.column_index == 0:
		EventBus.game_ended.emit(true)
	
	else:
		await action_handler.perform_actions(entity_data.action_sequence)
