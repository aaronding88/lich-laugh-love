class_name UnitSpawner
extends Node

signal unit_spawned(unit: Unit)

@export var game_area: PlayArea
@export var game_state: GameState

@onready var unit_scene_spawner: SceneSpawner = $SceneSpawner


func _ready() -> void:
	pass

func spawn_unit(unitStats: UnitStats) -> void:
	if game_area.unit_grid.is_grid_full():
		# TODO: User interface saying things are full
		print("Grid is full! No unit created")
		return
	
	# TODO: We need to also disable unit buying during game state. It should be
	# unavailable, but we should do it without omitting
	if not game_state.is_battling():
		var new_unit := unit_scene_spawner.spawn_scene(game_area.unit_grid) as Unit
		var tile := game_area.unit_grid.get_first_empty_tile()
		game_area.unit_grid.add_unit(tile, new_unit)
		# This would be nice to get added a certain way
		new_unit.global_position = game_area.get_global_from_tile(tile)
		new_unit.stats = unitStats
		unit_spawned.emit(new_unit)
