@tool
class_name MapColumn
extends Node2D

@export var tile_scene: PackedScene = preload("uid://bmifyrtst83yc")
@export var column_index: int

var tiles: Array[Tile]

func get_tile(index: int) -> Tile:
	return tiles[index]

func setup_column(number_of_tiles: int, column_index: int, tile_size: Vector2 = Vector2(100, 100), tile_spacing: Vector2 = Vector2(20, 20)):
	self.column_index = column_index

	for child in get_children():
		remove_child(child)
		child.queue_free()

	for i in number_of_tiles:
		var tile: Tile = tile_scene.instantiate()
		add_child(tile, true)
		tiles.append(tile)
		if Engine.is_editor_hint():
			tile.owner = get_tree().get_edited_scene_root()
		tile.position = Vector2(0, tile_size.y / 2 + i * (tile_size.y + tile_spacing.y))
		tile.sprite.rotation = deg_to_rad(randi_range(1, 100))
		tile.initialize(self, i)

func trigger_tiles():
	for tile in tiles:
		await tile.trigger()
