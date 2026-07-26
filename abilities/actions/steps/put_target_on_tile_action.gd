class_name PutTargetOnTileAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var selected_tile : Tile = action_handler.get_parameter("selected_tile")
	
	if selected_tile:
		selected_tile.place_target()
	
