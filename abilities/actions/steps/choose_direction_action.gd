class_name ChooseDirectionAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.pop_direction_buttons(true)
	
	var direction = await entity.direction_selected
	action_handler.set_parameter("direction", direction) # value is string (left, right, up, or down)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	await execute(action_handler, entity, grid_map)

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	pass