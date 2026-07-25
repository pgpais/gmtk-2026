class_name Overwatch
extends Object

var tile: Tile
var action_sequence: ActionSequence
var entity: Entity
var target_team: Entity.TEAMS

func _init(tile: Tile, action_sequence: ActionSequence, entity: Entity, target_team: Entity.TEAMS) -> void:
    self.tile = tile
    self.action_sequence = action_sequence
    self.entity = entity
    self.target_team = target_team

func check(entity: Entity) -> bool:
    if entity == self.entity: return false
    if entity.team != target_team: return false

    await self.entity.action_handler.perform_actions(action_sequence)

    return true