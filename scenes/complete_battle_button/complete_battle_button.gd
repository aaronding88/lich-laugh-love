class_name CompleteBattleButton
extends Button

@export var game_state: GameState
@export var battle_handler: BattleHandler

func _ready() -> void:
	pressed.connect(_on_pressed)
	game_state.changed.connect(_update)
	_update()

func _update() -> void:
	if game_state.is_completed():
		visible = true
	else:
		visible = false
	
func _on_pressed() -> void:
	if game_state.current_phase != GameState.Phase.COMPLETE:
		return
	
	game_state.current_phase = GameState.Phase.PREPARATION
	visible = false
