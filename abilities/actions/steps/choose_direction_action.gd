class_name ChooseDirectionAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.pop_direction_buttons(true)
	
	var direction = await entity.direction_selected
