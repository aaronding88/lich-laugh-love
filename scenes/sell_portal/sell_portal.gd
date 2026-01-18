class_name SellPortal
extends Area2D

@export var player_stats: PlayerStats

@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter
@onready var resource: HBoxContainer = %Resource
@onready var resource_label: Label = %ResourceLabel

var current_unit: Unit

func _ready() -> void:
	var units := get_tree().get_nodes_in_group("units")
	for unit: Unit in units:
		setup_unit(unit)
		
func setup_unit(unit: Unit) -> void:
	unit.drag_and_drop.dropped.connect(_on_unit_dropped.bind(unit))
	unit.quick_sell_pressed.connect(_sell_unit.bind(unit))

func _sell_unit(unit: Unit) -> void:
	player_stats.unit_pool.return_unit(unit.stats)
	player_stats.resource += unit.stats.resource_cost
	unit.queue_free()

func _on_unit_dropped(_starting_position: Vector2, unit: Unit) -> void:
	# Maybe optimizable
	if unit and unit == current_unit:
		_sell_unit(unit)

func _on_area_entered(unit: Unit) -> void:
	current_unit = unit
	outline_highlighter.highlight()
	resource_label.text = str(unit.stats.resource_cost)
	resource.show()

func _on_area_exited(unit: Unit) -> void:
	if unit and unit == current_unit:
		current_unit = null
		
	outline_highlighter.clear_highlight()
	resource.hide()
