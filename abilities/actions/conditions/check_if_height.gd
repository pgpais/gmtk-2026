class_name CheckIfHeight
extends ActionCondition

@export var check_height : int

func evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool:
	return false#entity.current_tile_index==check_height
