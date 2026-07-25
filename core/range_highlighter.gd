class_name RangeHighlighter
extends Node

static var instance: RangeHighlighter

@export var grid_map: LayerGridMap
@export var debug_range: AbilityRange

func _init() -> void:
	instance = self

func _ready() -> void:
	EventBus.request_highlight.connect(_on_highlight_request)

func _process(delta: float) -> void:
	if Input.is_key_pressed(Key.KEY_O):
		grid_map.get_tile(3, 3).show_positive_highlight()
		show_highlight_tiles(grid_map.get_tiles_in_range(debug_range, grid_map.get_tile(3, 3)), false)

func _on_highlight_request(target_type, selection_range, reference_tile) -> void:
	match target_type:
		Constants.TARGET_TYPES.TILE:
			var tiles: Array[Tile] = grid_map.get_tiles_in_range(selection_range, reference_tile)
			show_highlight_tiles(tiles)

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
