class_name UnitGrid
extends Node

signal unit_grid_changed

@export var placeable_cells: TileMapLayer

var units: Dictionary

func _ready() -> void:
	var used_cells = placeable_cells.get_used_cells()
	
	for cell: Vector2i in used_cells:
		units[cell] = null

func add_unit(tile: Vector2i, unit: Node) -> void:
	units[tile] = unit
	unit_grid_changed.emit()
	
func remove_unit(tile: Vector2i) -> void:
	var unit := units[tile] as Node
	
	if not unit:
		return
		
	units[tile] = null
	unit_grid_changed.emit()
	
func is_tile_occupied(tile: Vector2i) -> bool:
	return units[tile] != null
	
func is_grid_full() -> bool:
	return units.keys().all(is_tile_occupied)
	
func get_first_empty_tile() -> Vector2i:
	for tile in units:
		if not is_tile_occupied(tile):
			return tile
	
	# no empty tile
	return Vector2i(-1, -1)
	
func get_all_units() -> Array[Unit]:
	var unit_array: Array[Unit] = []
	
	for unit: Unit in units.values():
		if unit:
			unit_array.append(unit)
			
	return unit_array
