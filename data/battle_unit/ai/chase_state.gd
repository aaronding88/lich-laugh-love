class_name ChaseState
extends State

signal target_reached(target: BattleUnit)
signal stuck

var actor_unit: BattleUnit
var tween: Tween

func enter() -> void:
	actor_unit = actor as BattleUnit
	if _has_target_in_range():
		_end_chase()
	else:
		actor_unit.target_finder.find_target()
		actor_unit.target_finder.targets_in_range_changed.connect(_on_targets_in_range_changed)
		
func exit() -> void:
	if actor_unit.target_finder.targets_in_range_changed.is_connected(_on_targets_in_range_changed):
		actor_unit.target_finder.targets_in_range_changed.disconnect(_on_targets_in_range_changed)

func chase() -> void:
	if tween and tween.is_running():
		return
	
	if _has_target_in_range():
		return

	actor_unit.target_finder.find_target()
	var new_pos := UnitNavigation.get_next_position(actor_unit, actor_unit.target_finder.target)
	
	if new_pos == Vector2(-1, -1):
		if _has_target_in_range():
			_end_chase()
		else:
			stuck.emit()
		return
	
	var direction := UnitNavigation.vector_to_face(new_pos, actor_unit.global_position)

	tween = actor_unit.create_tween()
	tween.tween_callback(actor_unit.set_animation.bind("running", direction))
	tween.tween_property(actor_unit, "global_position", new_pos, 1.0 / actor_unit.stats.speed)
	tween.finished.connect(
		func():
			tween.kill()
			actor_unit.set_animation.bind("idle")
			if _has_target_in_range():
				_end_chase()
			else:
				chase()
	)

func _end_chase() -> void:
	target_reached.emit.call_deferred(actor_unit.target_finder.targets_in_range[0])

func _has_target_in_range() -> bool:
	return actor_unit.target_finder.has_target_in_range()
	
func _on_targets_in_range_changed() -> void:
	if not tween and _has_target_in_range():
		_end_chase()
