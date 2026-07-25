class_name ShockAction
extends Action

@export var toggle : bool = true

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.shock(toggle)
