class_name StartBattleButton
extends Button

@export var game_state: GameState
@export var player_stats: PlayerStats
@export var arena_grid: UnitGrid

@onready var label: Label = $Label

func _ready() -> void:
	pressed.connect(_on_pressed)
	player_stats.changed.connect(_update)
	arena_grid.unit_grid_changed.connect(_update)
	game_state.changed.connect(_update)
	_update()

func _update() -> void:
	var units_used := arena_grid.get_all_units().size()
	
	disabled = not game_state.is_preparing() or units_used == 0
	label.modulate.a = 0.5 if disabled else 1.0
	
func _on_pressed() -> void:
	if not game_state.is_preparing():
		return
	
	game_state.current_phase = GameState.Phase.BATTLE
	disabled = true
