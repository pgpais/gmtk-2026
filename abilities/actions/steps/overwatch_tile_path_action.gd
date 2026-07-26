class_name OverwatchTilePathAction
extends Action

@export var tile_test_scene: PackedScene
@export var tile_path_parameter_name: String = "tile_path"

@export var team: Entity.TEAMS
@export var action_sequence: ActionSequence

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    var tile_path: Array[Tile] = action_handler.get_parameter("tile_path")

    for tile in tile_path:
        tile.add_child(tile_test_scene.instantiate())
	
        if team == Entity.TEAMS.ALLY:
            tile.modulate = Color.AQUAMARINE
        else:
            tile.modulate = Color.RED
        
        var overwatch: Overwatch = Overwatch.new(tile, action_sequence, entity, team)
        tile.add_overwatch(overwatch)
        print("overwatch added to tile ", tile)