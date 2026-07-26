class_name OverwatchAction
extends Action

@export var tile_test_scene: PackedScene
@export var target_tile_parameter_name: String = "target_tile"

@export var team: Entity.TEAMS
@export var action_sequence: ActionSequence

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var target_tile = action_handler.get_parameter(target_tile_parameter_name)

	var test_instance: Node = null
	if tile_test_scene:
		test_instance = tile_test_scene.instantiate()
		target_tile.add_child(test_instance)
	
		if team == Entity.TEAMS.ALLY:
			test_instance.modulate = Color.AQUAMARINE
		else:
			test_instance.modulate = Color.RED
	
	var overwatch: Overwatch = Overwatch.new(target_tile, action_sequence, entity, team, test_instance)
	target_tile.add_overwatch(overwatch)
	print("overwatch added to tile ", target_tile)
