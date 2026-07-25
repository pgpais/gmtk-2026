class_name ShootAtEntityAction
extends Action

@export var parameter_name: String = "target_entity"

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    var target_entity: Entity = action_handler.get_parameter(parameter_name)
    target_entity.die()
