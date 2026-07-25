class_name ToggleParameterAction
extends Action

## Boolean parameter to toggle to a differen
@export var parameter_name: String
@export var starting_value: bool = true

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	if !action_handler.get_parameter(parameter_name):
		action_handler.set_parameter(parameter_name, starting_value)
		return
		
	action_handler.set_parameter(parameter_name, !action_handler.get_parameter(parameter_name))
