class_name CalculatePathActionToTile
extends Action

var target_tile_parameter_name: String = "target_tile"

var tile_path_parameter_name: String = "tile_path"

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    var target_tile = action_handler.get_parameter(target_tile_parameter_name)

    var path = grid_map.get_tile_path(entity.current_tile, target_tile, true)

    action_handler.set_parameter(tile_path_parameter_name, path)