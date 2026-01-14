class_name UnitMover
extends Node

@export var play_area: PlayArea


func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)
		
func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.drag_started.connect(_on_unit_drag_started.bind(unit))
	unit.drag_and_drop.drag_canceled.connect(_on_unit_drag_canceled.bind(unit))
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))

func _set_highlighters(enabled: bool) -> void:
	play_area.tile_highlighter.enabled = enabled

func _reset_unit_to_starting_position(starting_position: Vector2, unit: Unit) -> void:
	var tile := play_area.get_tile_from_global(starting_position)
	
	unit.reset_after_dragging(starting_position)
	play_area.unit_grid.add_unit(tile, unit)
	
func _move_unit(unit: Unit, tile: Vector2i) -> void:
	play_area.unit_grid.add_unit(tile, unit)
	unit.global_position = play_area.get_global_from_tile(tile)
	unit.reparent(play_area.unit_grid)

func _on_unit_drag_started(unit: Unit) -> void:
	_set_highlighters(true)
	
	if play_area.is_tile_in_bounds(unit.global_position):
		var tile := play_area.get_tile_from_global(unit.global_position)
		play_area.unit_grid.remove_unit(tile)

func _on_unit_drag_canceled(starting_position: Vector2i, unit: Unit) -> void:
	_set_highlighters(false)
	_reset_unit_to_starting_position(starting_position, unit)
	
func _on_unit_dropped(starting_position: Vector2, unit: Unit) -> void:
	_set_highlighters(false)

	var old_tile := play_area.get_tile_from_global(starting_position)
	var new_tile := play_area.get_hovered_tile()
	
	if not play_area.is_tile_in_bounds(new_tile):
		_reset_unit_to_starting_position(starting_position, unit)
		return
	
	# swap units if we have to
	if play_area.unit_grid.is_tile_occupied(new_tile):
		var old_unit: Unit = play_area.unit_grid.units[new_tile]
		play_area.unit_grid.remove_unit(new_tile)
		_move_unit(old_unit, old_tile)
	
	_move_unit(unit, new_tile)
