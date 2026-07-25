class_name IncreaseAttackDamageAction
extends Action

@export var amount: int = 1

func execute(action_handler: ActionHandler, entity: Entity, grid_map: LayerGridMap):
    entity.frog_king_damage += amount