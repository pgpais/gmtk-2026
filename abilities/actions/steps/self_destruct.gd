class_name SelfDestruct
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.queue_free()