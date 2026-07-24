extends Node

signal ticker_new_tick(count: int)
signal new_cycle

signal selection_needed(target_type, selection_range, highlight_range)
signal direction_selection_needed()
signal movement_needed()

signal entity_selected(entity: Entity)
signal tile_selected(tile: Tile)

signal action_step_performed
