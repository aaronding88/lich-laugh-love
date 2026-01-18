class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

const UNIT = preload("res://scenes/unit/unit.tscn")

@export var game_area: PlayArea


func _ready() -> void:
	pass

func spawn_unit(unitStats: UnitStats) -> void:
	if game_area.unit_grid.is_grid_full():
		# TODO: User interface saying things are full
		print("Grid is full! No unit created")
		return
	
	var new_unit := UNIT.instantiate()
	var tile := game_area.unit_grid.get_first_empty_tile()
	game_area.unit_grid.add_child(new_unit)
	game_area.unit_grid.add_unit(tile, new_unit)
	new_unit.global_position = game_area.get_global_from_tile(tile)
	new_unit.stats = unitStats
	unit_spawned.emit(new_unit)
