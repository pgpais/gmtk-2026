class_name PushEntity
extends Action

enum targets {
	EVERYONE,
	ONLY_ALLIES,
	ONLY_ENEMIES,
	SELECTED,
}

@export var target : targets

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var entities_to_push = []
	
	match target:
		targets.EVERYONE:
			entities_to_push = grid_map.get_entities_adjacent(entity.current_tile)
		targets.ONLY_ALLIES:
			entities_to_push = grid_map.get_allies_adjacent(entity.current_tile)
		targets.ONLY_ENEMIES:
			entities_to_push = grid_map.get_enemies_adjacent(entity.current_tile)
		targets.SELECTED:
			var selected_tile: Tile = action_handler.get_parameter("selected_tile")
			if selected_tile and selected_tile.entity:
				entities_to_push = [selected_tile.entity]
	
	for target_entity in entities_to_push:
		var distance_to_tile: Vector2 = grid_map.get_tile_coordinates(entity.current_tile) - grid_map.get_tile_coordinates(target_entity.current_tile)
		var direction_to_entity = distance_to_tile.normalized()

		await target_entity._move(direction_to_entity.x, direction_to_entity.y)
