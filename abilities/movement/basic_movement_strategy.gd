class_name BasicMovementStrategy
extends MovementStrategy

@export var movement_direction: Vector2i

func move(entity: Entity):
	entity.move(movement_direction.x, movement_direction.y)
