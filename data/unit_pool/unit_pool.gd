class_name UnitPool
extends Resource

signal unit_count_adjusted

@export var available_unit_types: Array[UnitStats]

var unit_pool: Dictionary

func generate_unit_pool() -> void:
	for unit: UnitStats in available_unit_types:
		if not unit_pool.find_key(unit.name):
			unit_pool[unit.name] = unit.unit_count
	
func purchase_unit(unit: UnitStats) -> void:
	if get_current_unit_count(unit) > 0:
		unit_pool[unit.name] -= 1
		unit_count_adjusted.emit()
	else:
		# TODO: Figure out what to do if they try to purchase and do not succeed
		printerr("Can't decrement unit - either at 0 or unit not in dict!")

func return_unit(unit: UnitStats) -> void:
	if unit_pool[unit.name]:
		unit_pool[unit.name] += 1
		unit_count_adjusted.emit()
	else:
		print_debug(unit.name, " is not in the unit pool for some reason. Adding")
		unit_pool[unit.name] = 1

func get_current_unit_count(unit: UnitStats) -> int:
	return unit_pool.get(unit.name, 0)
		
func no_available_unit(unit: UnitStats) -> bool:
	return unit_pool.get(unit.name, 0) <= 0
