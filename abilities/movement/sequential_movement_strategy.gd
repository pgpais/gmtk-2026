class_name SequentialMovementStrategy
extends MovementStrategy

@export var movement_directions: Array[Vector2i]

func move(entity: Entity):
	for direction in movement_directions:
		entity.move(direction.x, direction.y)
		await entity.finished_movement
