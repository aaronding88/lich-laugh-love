class_name DeathState
extends State

var actor_unit: BattleUnit

func enter() -> void:
	actor_unit = actor as BattleUnit
	UnitNavigation.clear_dead_unit_tile(actor_unit)

func exit() -> void:
	# if they ever revive, we can re-add the unit to the board this way.
	pass
