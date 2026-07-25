extends Resource
class_name SpawnData

@export var spawn_limit : int = 100
@export var possible_entity_datas : Array[EntityData]
@export_range(0, 1) var probability : float = 1
@export var special_spawn : bool = false

@export_range(0, 1) var repeat_probability : float

enum condition_names {
	check_if_3_frogs,
	spawned_special,
	cycle_divisible_by_8
}

var condition_match : Dictionary[condition_names, Callable] = {
	condition_names.check_if_3_frogs : check_if_3_frogs,
	condition_names.spawned_special : spawned_special,
	condition_names.cycle_divisible_by_8 : cycle_divisible_by_8
}
	
@export var conditions : Array[condition_names]

@export_range(0, 1) var hidden_probability : float

func check_all_conditions(spawn_handler : SpawnHandler, column_index : int) -> bool:
	for condition in conditions:
		if ! condition_match[condition].call(spawn_handler, column_index):
			return false
	
	return true
		
func check_if_3_frogs(spawn_handler : SpawnHandler, column_index : int) -> bool:
	var count = 0
	
	var grid_map = spawn_handler.grid_map
	var entities_in_column = grid_map.get_entities_in_column(column_index)
	
	if entities_in_column.is_empty():
		return true
	
	for entity in entities_in_column:
		if entity.team in [Entity.TEAMS.ALLY, Entity.TEAMS.NEUTRAL]:
			count += 1
	
	return count < 3
	
func spawned_special(spawn_handler : SpawnHandler, column_index : int) -> bool:
	return spawn_handler.special_spawned

func cycle_divisible_by_8(spawn_handler : SpawnHandler, column_index : int) -> bool:
	return spawn_handler.current_spawn_cycle % 7 == 0
