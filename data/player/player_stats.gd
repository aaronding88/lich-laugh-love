class_name PlayerStats
extends Resource

@export var resource: int : set = _set_resource
@export var xp: int : set = _set_xp
@export var level: int : set = _set_level
@export var unit_pool: UnitPool

func _set_resource(value: int) -> void:
	resource = value
	emit_changed()
	
func _set_xp(value: int) -> void:
	xp = value
	emit_changed()
	
func _set_level(value: int) -> void:
	level = value
	emit_changed()
	
