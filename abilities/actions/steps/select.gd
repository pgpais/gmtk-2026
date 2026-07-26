extends Action
class_name Select

@export var target_type: Constants.TARGET_TYPES
@export var target_team: Entity.TEAMS = Entity.TEAMS.ENEMY
@export var selection_range: AbilityRange
@export var highlight_selection_range: bool = true

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var valid_tiles = grid_map.get_valid_tiles(target_type, selection_range, entity.current_tile, target_team)
	
	if valid_tiles.is_empty():
		action_handler.reset()
		return
	
	EventBus.request_highlight.emit(target_type, selection_range, entity.current_tile, target_team, highlight_selection_range)

	var selected_tile: Tile = await EventBus.tile_selected
	
	var is_adjacent = (abs(selected_tile.column.column_index - entity.current_tile.column.column_index) <= 1
	and abs(selected_tile.tile_index - entity.current_tile.tile_index) <= 1)
	
	action_handler.set_parameter("target_is_adjacent", is_adjacent)

	match target_type:
		Constants.TARGET_TYPES.TILE:
			var distance_to_selected_tile = grid_map.get_tile_coordinates(selected_tile) - grid_map.get_tile_coordinates(entity.current_tile)
			var selected_direction = distance_to_selected_tile.normalized()
			action_handler.set_parameter("selected_tile", selected_tile)
			action_handler.set_parameter("selected_direction", selected_direction)
		Constants.TARGET_TYPES.ENTITY:
			var selected_entity = selected_tile.get_entity()
			var distance_to_selected_tile = grid_map.get_tile_coordinates(selected_tile) - grid_map.get_tile_coordinates(entity.current_tile)
			var selected_direction = distance_to_selected_tile.normalized()
			action_handler.set_parameter("selected_entity", selected_entity)
			action_handler.set_parameter("selected_direction", selected_direction)
		Constants.TARGET_TYPES.DIRECTION:
			var distance_to_selected_tile = grid_map.get_tile_coordinates(selected_tile) - grid_map.get_tile_coordinates(entity.current_tile)
			var selected_direction = distance_to_selected_tile.normalized()
			action_handler.set_parameter("selected_tile", selected_tile)
			action_handler.set_parameter("selected_direction", selected_direction)

func set_selectable_tiles(tiles: Array[Tile], state: bool):
	for tile in tiles:
		if tile.selectable:
			tile.selectable.set_selectable(state)
