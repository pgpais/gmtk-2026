class_name RotateToDirectionAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	await entity.rotate_to_direction(action_handler.parameters["selected_direction"])

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass