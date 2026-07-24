class_name BasicMovementStrategy
extends MovementStrategy

@export var movement_direction: Vector2i

func move(entity: Entity):
	entity._move(movement_direction.x, movement_direction.y)

func tiles_to_highlight(entity: Entity, grid_map: LayerGridMap) -> Array[Tile]:
	var tiles: Array[Tile] = grid_map.get_tiles_in_ability_range(ability_range, entity.current_tile)
	return tiles
