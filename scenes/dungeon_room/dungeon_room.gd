class_name DungeonRoom
extends Node2D

const CELL_SIZE := Vector2(256, 128)
const HALF_CELL_SIZE := Vector2(128, 64)
const QUARTER_CELL_SIZE := Vector2(64, 32)

@export var game_state: GameState
@export var ui_layer: CanvasLayer

@onready var game_area: PlayArea = $GameArea
@onready var battle_grid: UnitGrid = $GameArea/BattleUnitGrid
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_roster: UnitShop = %UnitRoster
@onready var sell_portal: SellPortal = %SellPortal
@onready var non_battle_ui: Control = %NonBattleUI
@onready var dungeon_map_button: DungeonMapButton = %DungeonMapButton

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_roster.unit_bought.connect(unit_spawner.spawn_unit)
	game_state.changed.connect(_toggle_non_battle_ui)
	
	UnitNavigation.initialize(battle_grid, game_area)
	
func _toggle_non_battle_ui() -> void:
	print("Dungeon room: game state changed to: ", game_state.current_phase)
	match game_state.current_phase:
		GameState.Phase.PREPARATION:
			non_battle_ui.visible = true
		GameState.Phase.BATTLE:
			non_battle_ui.visible = false
		GameState.Phase.COMPLETE:
			non_battle_ui.visible = false
	
func _pause_and_hide():
	hide()
	ui_layer.hide()
	process_mode = PROCESS_MODE_DISABLED

func _resume_and_show():
	show()
	ui_layer.show()
	process_mode = PROCESS_MODE_INHERIT
