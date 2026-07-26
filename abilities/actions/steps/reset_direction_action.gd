class_name ResetDirectionAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	await entity.reset_direction()
