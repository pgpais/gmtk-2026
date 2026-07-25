class_name ShootAtAction
extends Action

@export var tile_position : Vector2i

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	entity.shoot_at(tile_position)
