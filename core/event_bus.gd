extends Node

signal ticker_new_tick(count: int)
signal new_cycle

signal request_highlight(target_type, range, reference_tile)
signal direction_selection_needed()
signal movement_needed()

signal entity_selected(entity: Entity)
signal tile_selected(tile: Tile)
signal direction_selected(direction: Vector2)

signal request_enemy_spawn(tile, enemy_data)

signal action_step_performed
signal enemy_attacked_frog_king(enemy: Enemy)

signal game_ended(win: bool)
