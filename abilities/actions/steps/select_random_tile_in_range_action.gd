extends Action
class_name SelectRandomTileInRangeAction

@export var selection_range: AbilityRange

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var tiles: Array[Tile] = grid_map.get_tiles_in_range(selection_range, entity.current_tile)
	
	tiles.shuffle()
	
	var selected_tile = null
	
	for tile in tiles:
		if ! tile.entity:
			selected_tile = tile 
			break
	
	action_handler.set_parameter("selected_tile", selected_tile)
