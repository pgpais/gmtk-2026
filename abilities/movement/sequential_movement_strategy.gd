class_name SequentialMovementStrategy
extends MovementStrategy

@export var movement_directions: Array[Vector2i]

func move(entity: Entity):
	for direction in movement_directions:
		entity._move(direction.x, direction.y)
		await entity.finished_movement

func tiles_to_highlight(entity: Entity, grid_map: LayerGridMap) -> Array[Tile]:
	var tiles: Array[Tile] = grid_map.get_tiles_in_ability_range(ability_range, entity.current_tile)
	return tiles
