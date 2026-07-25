class_name ParameterCondition
extends ActionCondition

@export var parameter_name: String

func evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool:
	return action_handler.get_parameter(parameter_name) == true
