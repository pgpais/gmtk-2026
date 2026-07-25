class_name MoveAction
extends Action

@export var move_strategy: MovementStrategy

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	move_strategy.call_deferred("move", entity)

	await entity.finished_movement
