class_name ShootAtAction
extends Action

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var selected_tile = action_handler.get_parameter("selected_tile")
	
	if ! selected_tile:
		selected_tile = action_handler.get_parameter("overwatch_entity").current_tile
		
	if selected_tile:
		entity.shoot_at(selected_tile)
		selected_tile.hide_target()
