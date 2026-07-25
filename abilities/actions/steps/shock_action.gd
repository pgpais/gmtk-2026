class_name ShockAction
extends Action

#@export 
var toggle : bool = false

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	toggle = !toggle
	entity.shock(toggle)
