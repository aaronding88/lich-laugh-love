class_name BattleHandler
extends Node

signal player_won
signal enemy_won

const ENEMY_TEST_POSITIONS := [
	Vector2i(1, 5),
	Vector2i(2, 5),
	Vector2i(3, 5),
	Vector2i(4, 5)
]

const ENEMY := preload("res://data/enemies/halberd/halberd.tres")

@export var game_state: GameState
@export var game_area: PlayArea
@export var game_area_unit_grid: UnitGrid
@export var battle_unit_grid: UnitGrid

@onready var scene_spawner: SceneSpawner = $SceneSpawner

var player_test: BattleUnit
var enemy_test: BattleUnit
var enemy_target: BattleUnit
var player_target: BattleUnit

func _ready() -> void:
	game_state.changed.connect(_on_game_state_changed)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("test1"):
		var ai_unit := get_tree().get_nodes_in_group("player_units")[0] as BattleUnit
		ai_unit.unit_ai.enabled = true
		
	if event.is_action_pressed("test2"):
		var new_pos := UnitNavigation.get_next_position(enemy_test, enemy_target)
		if new_pos == Vector2(-1, -1):
			return
		var new_pos_tile_vector := game_area.get_tile_from_global(new_pos)
		var old_pos_tile_vector := game_area.get_tile_from_global(enemy_test.global_position)
		var direction := new_pos_tile_vector -old_pos_tile_vector

		var enemy_tween = enemy_test.create_tween()
		enemy_tween.tween_property(enemy_test, "global_position", new_pos, 0.5)
		enemy_tween.tween_callback(enemy_test.set_animation.bind("idle", direction))
		enemy_test.set_animation("running", direction)
		
	if event.is_action_pressed("test3"):
		get_tree().call_group("player_units", "queue_free")
	
func _setup_battle_units(unit_coord: Vector2i, new_unit: BattleUnit) -> void:
	new_unit.global_position = game_area.get_global_from_tile(unit_coord)
	new_unit.tree_exited.connect(_on_battle_unit_died)
	battle_unit_grid.add_unit(unit_coord, new_unit)
	
func _clean_up_fight() -> void:
	get_tree().call_group("player_units", "queue_free")
	get_tree().call_group("enemy_units", "queue_free")
	get_tree().call_group("units", "show")
	
func _prepare_fight() -> void:
	get_tree().call_group("units", "hide")
	
	for unit_coord: Vector2i in game_area_unit_grid.get_all_occupied_tiles():
		var unit: Unit = game_area_unit_grid.units[unit_coord]
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("player_units")
		new_unit.stats = unit.stats
		new_unit.stats.team = UnitStats.Team.PLAYER
		_setup_battle_units(unit_coord, new_unit)
		
	for unit_coord: Vector2i in ENEMY_TEST_POSITIONS:
		var new_unit := scene_spawner.spawn_scene(battle_unit_grid) as BattleUnit
		new_unit.add_to_group("enemy_units")
		new_unit.stats = ENEMY
		new_unit.stats.team = UnitStats.Team.ENEMY
		_setup_battle_units(unit_coord, new_unit)
		
	# Testing code
	player_test = get_tree().get_nodes_in_group("player_units")[0]
	enemy_test = get_tree().get_nodes_in_group("enemy_units")[1]
	player_target = get_tree().get_nodes_in_group("enemy_units").pick_random()
	enemy_target = get_tree().get_nodes_in_group("player_units").pick_random()
		
func _on_battle_unit_died() -> void:
	# We already concluded the battle or we are quitting
	print("Battle unit died")
	if not get_tree() or game_state.current_phase == GameState.Phase.PREPARATION:
		return
		
	if get_tree().get_node_count_in_group("enemy_units") == 0:
		print("player won!")
		game_state.current_phase = GameState.Phase.PREPARATION
		player_won.emit()
	if get_tree().get_node_count_in_group("player_units") == 0:
		print("enemy won!")
		game_state.current_phase = GameState.Phase.PREPARATION
		enemy_won.emit()
	
func _on_game_state_changed() -> void:
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			_clean_up_fight()
		GameState.Phase.BATTLE:
			_prepare_fight()
