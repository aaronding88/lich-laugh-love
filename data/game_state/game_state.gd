class_name GameState
extends Resource

# We could also have a battle-complete phase
enum Phase {
	PREPARATION,
	BATTLE,
	COMPLETE
}

@export var current_phase: Phase:
	set(value):
		current_phase = value
		changed.emit()

func is_battling() -> bool:
	return current_phase == Phase.BATTLE
	
func is_completed() -> bool:
	return current_phase == Phase.COMPLETE
	
func is_preparing() -> bool:
	return current_phase == Phase.PREPARATION
