class_name ChooseClosestTargetAction
extends Action

@export var group_name: StringName

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    var possible_targets: Array[Node] = entity.get_tree().get_nodes_in_group(group_name)

    var closest_target = null
    var closest_target_distance: float = 0.0

    for target in possible_targets:
        if target is not Entity: continue

        var distance = entity.global_position.distance_to(target.global_position)

        if closest_target == null or distance < closest_target_distance:
            closest_target = target
            closest_target_distance = distance

    if closest_target == null:
        action_handler.set_parameter("target", null)
        return

    action_handler.set_parameter("target", closest_target)
