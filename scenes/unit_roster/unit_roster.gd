class_name UnitShop
extends Control

signal unit_bought(unit: UnitStats)

const UNIT_CARD = preload("res://scenes/unit_card/unit_card.tscn")

@export var player_stats: PlayerStats

func _ready() -> void:
	player_stats.unit_pool.generate_unit_pool()
	
	for child: Node in get_children():
		child.queue_free()
		
	for unit_stats: UnitStats in player_stats.unit_pool.available_unit_types:
		var new_card: UnitCard = UNIT_CARD.instantiate()
		new_card.unit_stats = unit_stats
		new_card.unit_bought.connect(_on_unit_bought)
		add_child(new_card)

		
func _on_unit_bought(unit: UnitStats) -> void:
	unit_bought.emit(unit)
