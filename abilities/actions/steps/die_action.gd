class_name DieAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.die()
	entity.queue_free()
