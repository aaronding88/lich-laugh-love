class_name DungeonRoom
extends Node2D

const CELL_SIZE := Vector2(256, 128)
const HALF_CELL_SIZE := Vector2(128, 64)
const QUARTER_CELL_SIZE := Vector2(64, 32)


@onready var game_area: PlayArea = $GameArea
@onready var battle_grid: UnitGrid = $GameArea/BattleUnitGrid
@onready var unit_spawner: UnitSpawner = $UnitSpawner
@onready var unit_mover: UnitMover = $UnitMover
@onready var unit_roster: UnitShop = %UnitRoster
@onready var sell_portal: SellPortal = %SellPortal

func _ready() -> void:
	unit_spawner.unit_spawned.connect(unit_mover.setup_unit)
	unit_spawner.unit_spawned.connect(sell_portal.setup_unit)
	unit_roster.unit_bought.connect(unit_spawner.spawn_unit)
	
	UnitNavigation.initialize(battle_grid, game_area)
