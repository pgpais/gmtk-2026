class_name ChooseClosestTargetAction
extends Action

## Group to look for the closest target (required)
@export var group_name: StringName

@export var parameter_name: String = "target"

## If range should be visualized (for debug purposes)
@export var visualize_range: bool = false

## Range to look for the closest target (not required)
@export var range: AbilityRange

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
	var possible_targets: Array[Node]
	if range:
		var possible_tiles = grid_map.get_tiles_in_range(range, entity.current_tile)
		if visualize_range:
			var tile_highlighter: RangeHighlighter = entity.get_tree().current_scene.get_node("RangeHighlighter")
			tile_highlighter.hide_highlight_tiles(possible_tiles)

		for tile in possible_tiles:
			var entity_at_tile = tile.get_entity()
			if entity_at_tile and entity_at_tile.is_in_group(group_name):
				possible_targets.append(entity_at_tile)
	else:
		possible_targets = entity.get_tree().get_nodes_in_group(group_name)

	var closest_target = null
	var closest_target_distance: float = 0.0

	for target in possible_targets:
		if target is not Entity: continue

		var distance = entity.global_position.distance_to(target.global_position)

		if closest_target == null or distance < closest_target_distance:
			closest_target = target
			closest_target_distance = distance

	if closest_target == null:
		action_handler.set_parameter(parameter_name, null)
		return

	action_handler.set_parameter(parameter_name, closest_target)
