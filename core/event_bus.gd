extends Node

signal ticker_new_tick(count: int)
signal tick_triggers_finished
signal new_cycle

signal request_highlight(target_type, range, reference_tile, team, highlight)
signal direction_selection_needed()
signal movement_needed()

signal entity_selected(entity: Entity)
signal ally_selected(entity : Entity)
signal tile_selected(tile: Tile)
signal cancel_interaction()

signal direction_selected(direction: Vector2)

signal request_enemy_spawn(tile, enemy_data)

signal enemy_attacked_frog_king(enemy: Enemy)

signal ally_action_performed
signal player_action_performed

signal game_ended(win: bool)

func _ready() -> void:
	new_cycle.emit.call_deferred()
