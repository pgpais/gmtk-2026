class_name SpawnHandler
extends Node

var current_spawn_cycle : int = 0

@export var ally_spawn_cycles : Array[SpawnSequence]
@export var enemy_spawn_cycles : Array[SpawnSequence]

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
	EventBus.request_enemy_spawn.connect(_on_enemy_spawn_requested)

func _on_enemy_spawn_requested(tile: Tile, enemy_data: EnemyData):
	_spawn_enemy(enemy_data, tile)

func cycle():
	special_spawned = false
	
	var ally_cycle : SpawnSequence
	var enemy_cycle : SpawnSequence
	
	if current_spawn_cycle < len(ally_spawn_cycles):
		ally_cycle = ally_spawn_cycles[current_spawn_cycle]
	elif len(ally_spawn_cycles) > 0:
		ally_cycle = ally_spawn_cycles[-1] # if no more spawn sequences, use the last spawn sequence
	
	if current_spawn_cycle < len(enemy_spawn_cycles):
		enemy_cycle = enemy_spawn_cycles[current_spawn_cycle]
	elif len(enemy_spawn_cycles) > 0:
		enemy_cycle = enemy_spawn_cycles[-1] # if no more spawn sequences, use the last spawn sequence
	
	if ally_cycle:
		spawn_from_sequence(ally_cycle)
		
	if enemy_cycle:
		spawn_from_sequence(enemy_cycle)

func spawn_from_sequence(cycle : SpawnSequence):
	for spawn_data : SpawnData in cycle.spawn_sequence:
		var column_indexes
		
		if spawn_data.spawn_in_all_columns:
			column_indexes = spawn_data.column_indexes
		else:
			column_indexes = [spawn_data.column_indexes.pick_random()]
			
		for column_index in column_indexes:
			if grid_map.is_column_full(column_index):
				continue				
			
			if spawn_data.check_all_conditions(self, column_index) and randf_range(0, 1) <= spawn_data.probability:
				if spawn_data.special_spawn:
					special_spawned = true
				
				var entity_data = spawn_data.possible_entity_datas.pick_random()
				var tile : Tile = grid_map.get_random_empty_tile(column_index) # get a random tile
				
				var hidden = randf_range(0, 1) <= spawn_data.hidden_probability
				
				if entity_data.team == Entity.TEAMS.ALLY:
					_spawn_ally(entity_data, tile, hidden)
				elif entity_data.team == Entity.TEAMS.ENEMY:
					_spawn_enemy(entity_data, tile, hidden)
					
		current_spawn_cycle += 1

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
