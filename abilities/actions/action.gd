@abstract
extends Resource
class_name Action

@abstract func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap)

@abstract func enable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap)

@abstract func disable_preview(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap)