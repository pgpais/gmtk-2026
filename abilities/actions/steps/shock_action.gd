class_name ShockAction
extends Action

@export var parameter_name: String = "willShock"
@export var toggle: bool = false

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var parameter = action_handler.get_parameter(parameter_name)
	if parameter is bool:
		toggle = parameter
	
	entity.shock(toggle)
