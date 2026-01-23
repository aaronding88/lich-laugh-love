extends Node

signal path_calculated(points: Array[Vector2i], moving_unit: BattleUnit)

var battle_grid: UnitGrid
var game_area: PlayArea
var astar_grid: AStarGrid2D
var full_grid_region: Rect2i


func initialize(grid: UnitGrid, area: PlayArea) -> void:
	battle_grid = grid
	game_area = area
	
	full_grid_region = Rect2i(Vector2i(0, 0), game_area.map_size)
	astar_grid = AStarGrid2D.new()
	astar_grid.region = full_grid_region
	astar_grid.cell_size = DungeonRoom.CELL_SIZE
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.cell_shape = AStarGrid2D.CellShape.CELL_SHAPE_ISOMETRIC_DOWN
	astar_grid.update()
	#block_tiles_outside_arena()
	battle_grid.unit_grid_changed.connect(update_occupied_tiles)
	
	# Set up solid point outside rect
	
# TODO: maybe there's a better way than filling the whole arena?
func update_occupied_tiles() -> void:
	astar_grid.fill_solid_region(full_grid_region, false)
	#block_tiles_outside_arena()
	for id: Vector2i in battle_grid.get_all_occupied_tiles():
		astar_grid.set_point_solid(id)

## @deprecated: Don't need to block outside arena, but still maybe valuable
## to use later
func block_tiles_outside_arena() -> void:
	var rect := full_grid_region

	for x in rect.size.x:
		for y in rect.size.y:
			var cell := Vector2i(x, y)
			if not game_area.is_tile_in_bounds(cell):
				astar_grid.set_point_solid(cell)

func get_next_position(moving_unit: BattleUnit, target_unit: BattleUnit) -> Vector2:
	var unit_tile := game_area.get_tile_from_global(moving_unit.global_position)
	var target_tile := game_area.get_tile_from_global(target_unit.global_position)
	
	# Step 1: remove the unit's current position as a solid
	# and calculate path
	astar_grid.set_point_solid(unit_tile, false)
	var path := astar_grid.get_id_path(unit_tile, target_tile, true)
	path_calculated.emit(path, moving_unit)
	
	# Step 2: When there is no adjacent tile next tot he moving unit
	# we stay there and add it back as a solid
	if path.size() == 1 and path[0] == unit_tile:
		astar_grid.set_point_solid(unit_tile, true)
		return Vector2(-1, -1)
	
	# Step 3: but when there is a valid next tile, we update the grid,
	# set the next position to solid, and return the new coordinates
	var next_tile := path[1]
	battle_grid.remove_unit(unit_tile)
	battle_grid.add_unit(next_tile, moving_unit)
	astar_grid.set_point_solid(next_tile, true)
	
	return game_area.get_global_from_tile(next_tile)
	
