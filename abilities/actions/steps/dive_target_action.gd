class_name DiveTargetAction
extends Action

@export var target_parameter_name: String = "target"

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    var target: Entity = action_handler.get_parameter(target_parameter_name)
    entity.dive(target)