class_name PlayArea
extends TileMapLayer

@export var unit_grid: UnitGrid
@export var tile_highlighter: TileHighlighter
@export var map_size: Vector2i

@onready var play_area_floor: TileMapLayer = $Floor

var used_cells: Array[Vector2i]

func _ready() -> void:
	used_cells = play_area_floor.get_used_cells()
	
func get_tile_from_global(global: Vector2) -> Vector2i:
	return local_to_map(to_local(global))

func get_global_from_tile(tile: Vector2i) -> Vector2i:
	return to_global(map_to_local(tile))

func get_hovered_tile() -> Vector2i:
	return local_to_map(get_local_mouse_position())
	
func is_tile_in_bounds(tile: Vector2i) -> bool:
	return used_cells.has(tile)
