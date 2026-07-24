class_name SpawnHandler
extends Node

@onready var grid_map : LayerGridMap = LayerGridMap.instance

@export var enemies_data : Array[EnemyData]
@export var allies_data : Array[AllyData]

@export var enemiesParent : Node
@export var alliesParent : Node

func _ready() -> void:
	EventBus.new_cycle.connect(test)

func test():
	spawn_enemies(3)
	spawn_allies(3)

func spawn_enemies(n):
	var start_layer = len(grid_map.columns) - 1
	
	for i in n:
		var enemy_data : EnemyData = enemies_data.pick_random()
		
		var tile : Tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		
		if tile:		
			_spawn_enemy(enemy_data, tile)

func _spawn_enemy(enemy_data: EnemyData, tile: Tile):
	var enemy_scene : PackedScene = enemy_data.scene 
	var enemy : Enemy = enemy_scene.instantiate()
	
	enemiesParent.add_child(enemy, true)
	enemy.set_data(enemy_data)
	enemy.set_tile(tile)
	enemy.set_new_position(tile.global_position)
	tile.set_entity(enemy)

func spawn_allies(n):
	var start_layer = 0
	
	for i in n:
		var ally_data : AllyData = allies_data.pick_random()
		var tile : Tile = grid_map.get_random_empty_tile(start_layer) # get a random start tile
		
		if tile:
			_spawn_ally(ally_data, tile)

func _spawn_ally(ally_data: AllyData, tile: Tile):
	var ally_scene : PackedScene = ally_data.scene
	var ally : Ally = ally_scene.instantiate()
	
	alliesParent.add_child(ally, true)
	ally.set_data(ally_data)
	ally.set_tile(tile)
	ally.set_new_position(tile.global_position)
	tile.set_entity(ally)
