class_name Overwatch
extends RefCounted

var tile: Tile
var action_sequence: ActionSequence
var entity: Entity
var target_team: Entity.TEAMS
var test_scene: Node

func _init(tile: Tile, action_sequence: ActionSequence, entity: Entity, target_team: Entity.TEAMS, test_scene: Node = null) -> void:
    self.tile = tile
    self.action_sequence = action_sequence
    self.entity = entity
    self.target_team = target_team
    self.test_scene = test_scene

func check(entity: Entity) -> bool:
    if entity == self.entity: return false
    if entity.team != target_team: return false

    self.entity.action_handler.set_parameter("overwatch_entity", entity)
    await self.entity.action_handler.perform_actions(action_sequence)

    return true

func remove_self():
    test_scene.queue_free()