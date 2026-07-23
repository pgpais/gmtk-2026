@tool
class_name Tile
extends Area2D

## The tile where units on this tile will move to
@export var next_tile: Tile
@export var previous_tiles: Array[Tile]
var previous_tile: Tile:
    get:
        return previous_tiles[randi_range(0, 1)]

@export var tile_above: Tile
@export var tile_below: Tile

@export var tile_index: int = 0:
    set(value):
        tile_index = value
        _scale_tile()
@export var tile_size_multiplier: int:
    set(value):
        tile_size_multiplier = value
        _scale_tile()

@export var layer: Layer

@export_group("Parameters")
@export var tile_size: Vector2 = Vector2(64, 64)


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func initialize(layer: Layer, tile_index: int):
    self.tile_index = tile_index
    self.layer = layer

func _ready():
    collision_shape.shape = RectangleShape2D.new()
    collision_shape.shape.size = tile_size
    _scale_tile()

    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
    var tween = create_tween()
    tween.tween_method(_set_modulate, sprite.modulate, Color(1, 1, 1, 0.5), 0.1)

func _on_mouse_exited():
    var tween = create_tween()
    tween.tween_method(_set_modulate, sprite.modulate, Color(1, 1, 1, 1), 0.1)

func _set_modulate(color: Color):
    sprite.modulate = color

func _scale_tile():
    var new_tile_size: int = tile_size.y * tile_size_multiplier
    if collision_shape:
        collision_shape.shape.size.y = new_tile_size
        # collision_shape.position.y = tile_size.y * (tile_size_multiplier - 1) / 2
    if sprite:
        sprite.scale.y = tile_size_multiplier / 2.0
        # sprite.position.y = tile_size.y * (tile_size_multiplier - 1) / 2.0
    position.y = new_tile_size / 2 + new_tile_size * tile_index

func _draw() -> void:
    if next_tile:
        draw_line(Vector2.ZERO, next_tile.global_position - global_position, Color.YELLOW)