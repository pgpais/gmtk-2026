class_name SpawnHandler
extends Node

@export var grid: LayerGridMap
@export var enemiesParent: Node

func _spawn_enemy(enemy_scene: PackedScene, tile: Tile):
	var enemy = enemy_scene.instantiate() # TODO: add type
	enemiesParent.add_child(enemy, true)
	enemy.set_tile(tile)
