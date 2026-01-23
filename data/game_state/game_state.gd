class_name GameState
extends Resource

# We could also have a battle-complete phase
enum Phase {
	PREPARATION,
	BATTLE
}

@export var current_phase: Phase:
	set(value):
		current_phase = value
		changed.emit()

func is_battling() -> bool:
	return current_phase == Phase.BATTLE
