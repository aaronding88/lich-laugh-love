class_name VictoryState
extends State

var actor_unit: BattleUnit

func enter() -> void:
	actor_unit = actor as BattleUnit

func exit() -> void:
	pass
