class_name SpawnHandler
extends Node

var current_spawn_cycle : int = 0

@export var spawn_cycles : Array[SpawnCycle]

@onready var grid_map : LayerGridMap = LayerGridMap.instance

@export var enemy_scene: PackedScene
@export var enemies_data: Array[EnemyData]

@export var ally_scene: PackedScene
@export var allies_data: Array[AllyData]

@export var enemiesParent: Node
@export var alliesParent: Node

@export var special_spawned : bool = false

func _ready() -> void:
	EventBus.new_cycle.connect(cycle)

func cycle():
	for cycle in spawn_cycles:
		if current_spawn_cycle >= cycle.min_cycle and current_spawn_cycle <= cycle.max_cycle:
			for spawn_sequence in cycle.spawn_sequences:
				spawn_from_sequence(spawn_sequence)
				
	current_spawn_cycle += 1
			
func spawn_from_sequence(spawn_sequence : SpawnSequence):
	special_spawned = false
	
	var spawn_datas = spawn_sequence.spawn_datas # to control spawn limits
	var spawn_count = []
	spawn_count.resize(len(spawn_datas))
	spawn_count.fill(0)
	
	var column_indexes = spawn_sequence.column_indexes
	
	column_indexes.shuffle()
	
	for column_index in column_indexes:
		var column_spawn_count = 0
		
		if grid_map.is_column_full(column_index):
				continue
		
		for i in range(len(spawn_sequence.spawn_datas)):
			var first_time = true
			
			var spawn_data : SpawnData = spawn_sequence.spawn_datas[i]
				
			while first_time or randf_range(0, 1) < spawn_data.repeat_probability:
				
				first_time = false
				
				if (
					spawn_count[i] < spawn_data.spawn_limit
					and spawn_data.check_all_conditions(self, column_index)
					and randf_range(0, 1) < spawn_data.probability
				) :
					var entity_data = spawn_data.possible_entity_datas.pick_random()
					var tile : Tile = grid_map.get_random_empty_tile(column_index) # get a random tile
					
					if ! tile:
						break
					
					var hidden = randf_range(0, 1) < spawn_data.hidden_probability
					
					if entity_data.team == Entity.TEAMS.ALLY:
						_spawn_ally(entity_data, tile, hidden)
					elif entity_data.team == Entity.TEAMS.ENEMY:
						_spawn_enemy(entity_data, tile, hidden)
					
					spawn_count[i] += 1
					
					if spawn_data.special_spawn:
						special_spawned = true
				
		if column_spawn_count >= spawn_sequence.spawn_limit_per_column:
			continue
						
	if randf_range(0, 1) < spawn_sequence.repeat_probability:
		spawn_from_sequence(spawn_sequence)

func spawn_enemies(n):
	var start_layer = len(grid_map.columns) - 1
	
	for i in n:
		var enemy_data : EnemyData = enemies_data.pick_random()
		
		var tile : Tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		
		if tile:		
			_spawn_enemy(enemy_data, tile)

func _spawn_enemy(enemy_data: EnemyData, tile: Tile, hidden : bool = false):
	var enemy : Enemy = enemy_scene.instantiate()
	
	enemiesParent.add_child(enemy, true)
	enemy.set_data(enemy_data)
	enemy.set_tile(tile)
	enemy.set_new_position(tile.global_position)
	tile.set_entity(enemy)
	
	if hidden:
		pass
		#TODO some frogs spawn hidden (you do not know what they are)
	
	enemy.modulate = enemy_data.color # to test

func spawn_allies(n):
	var start_layer = 0
	
	for i in n:
		var ally_data : AllyData = allies_data.pick_random()
		var tile : Tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		
		if tile:
			_spawn_ally(ally_data, tile)

func _spawn_ally(ally_data: AllyData, tile: Tile, hidden : bool = false):
	var ally : Ally = ally_scene.instantiate()
	
	alliesParent.add_child(ally, true)
	ally.set_data(ally_data)
	ally.set_tile(tile)
	ally.set_new_position(tile.global_position)
	tile.set_entity(ally)
	
	ally.modulate = ally_data.color # to test
