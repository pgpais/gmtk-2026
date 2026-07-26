class_name MoveAction
extends Action

@export var direction: Vector2i

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	# move_strategy.call_deferred("move", entity)
	entity.call_deferred("_move", direction.x, direction.y)

	await entity.finished_movement

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var last_tile = grid_map.get_tile(entity.current_tile.column.column_index, entity.current_tile.tile_index)
	entity.preview_tile = last_tile
	last_tile.show_positive_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var last_tile = grid_map.get_tile(entity.current_tile.column.column_index, entity.current_tile.tile_index)
	entity.preview_tile = null
	last_tile.hide_positive_highlight()
