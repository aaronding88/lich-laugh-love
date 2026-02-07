class_name TargetFinder
extends Node

signal targets_in_range_changed

@export var actor: BattleUnit

var target: BattleUnit
var targets_in_range: Array[BattleUnit]


func _ready() -> void:
	actor.ready.connect(
		func():
			actor.detect_range.area_entered.connect(_on_area_entered)
			actor.detect_range.area_exited.connect(_on_area_exited)
	, CONNECT_ONE_SHOT
	)

func find_target() -> void:
	var opposing_group: String = UnitStats.TARGET[actor.stats.team]
	var all_targets := actor.get_tree().get_nodes_in_group(opposing_group)
	# It might be nice to get a test for this...
	var distances := all_targets.map(
		func(target_candidate: BattleUnit) -> float:
			var actor_pos = UnitNavigation.screen_to_iso(actor.global_position)
			var target_pos = UnitNavigation.screen_to_iso(target_candidate.global_position)
			return actor_pos.distance_squared_to(target_pos)
	)
	var idx := distances.find(distances.min())
	
	target = all_targets[idx]
	
func has_target_in_range() -> bool:
	return targets_in_range.size() > 0
	
func _on_area_entered(area: Area2D) -> void:
	if not area is BattleUnit:
		return
	
	targets_in_range.append(area)
	targets_in_range_changed.emit()
	
func _on_area_exited(area: Area2D) -> void:
	if not area is BattleUnit:
		return
	
	targets_in_range.erase(area)
	targets_in_range_changed.emit()
	
