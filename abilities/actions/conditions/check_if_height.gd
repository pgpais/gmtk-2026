class_name CheckIfHeight
extends ActionCondition

@export var check_height: int

func evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool:
	print("height:", entity.current_tile.tile_index)
	return entity.current_tile.tile_index == check_height

func preview_evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool:
	return entity.preview_tile.tile_index == check_height