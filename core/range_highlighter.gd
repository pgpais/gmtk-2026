class_name RangeHighlighter
extends Node

static var instance: RangeHighlighter

@export var grid_map: LayerGridMap

@export var debug_range: AbilityRange

func _init() -> void:
	instance = self

func show_highlight_tiles(tiles: Array[Tile], is_positive: bool = true):
	for tile in tiles:
		if is_positive:
			tile.show_positive_highlight()
		else:
			tile.show_danger_highlight()

func hide_highlight_tiles(tiles: Array[Tile], is_positive: bool = true) -> void:
	for tile in tiles:
		if is_positive:
			tile.hide_positive_highlight()
		else:
			tile.hide_danger_highlight()
