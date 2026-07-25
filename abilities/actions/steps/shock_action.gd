class_name ShockAction
extends Action

@export var parameter_name: String = "willShock"
@export var toggle: bool = false

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var toggle: bool = action_handler.get_parameter(parameter_name)
	entity.shock(toggle)
