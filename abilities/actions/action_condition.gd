@abstract class_name ActionCondition
extends Resource

@abstract func evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool

@abstract func preview_evaluate(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap) -> bool