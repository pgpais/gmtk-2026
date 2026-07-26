class_name PushEntity
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter("selected_tile")
	
	var distance_to_tile: Vector2 = grid_map.get_tile_coordinates(tile) - grid_map.get_tile_coordinates(entity.current_tile)
	var direction_to_entity = distance_to_tile.normalized()

	tile.get_entity()._move(direction_to_entity.x, direction_to_entity.y)

func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter("selected_tile")
	tile.show_danger_highlight()

func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tile: Tile = action_handler.get_parameter("selected_tile")
	tile.hide_danger_highlight()