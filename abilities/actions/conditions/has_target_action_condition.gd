class_name HasTargetActionCondition
extends ActionCondition

func evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool:
    return action_handler.get_parameter("target") != null