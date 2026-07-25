class_name OverwatchAction
extends Action

@export var tile_test_scene: PackedScene
@export var target_tile_parameter_name: String = "target_tile"

@export var team: Entity.TEAMS
@export var action_sequence: ActionSequence

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var target_tile = action_handler.get_parameter(target_tile_parameter_name)
	target_tile.add_child(tile_test_scene.instantiate())
	
	if team == Entity.TEAMS.ALLY:
		target_tile.modulate = Color.AQUAMARINE
	else:
		target_tile.modulate = Color.RED
	
	var overwatch: Overwatch = Overwatch.new(target_tile, action_sequence, entity, team)
	target_tile.add_overwatch(overwatch)
	print("overwatch added to tile ", target_tile)
