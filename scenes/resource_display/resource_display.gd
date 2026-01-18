class_name ResourceDisplay
extends HBoxContainer

@export var player_stats: PlayerStats

@onready var unit_resource: Label = $Resource

func _ready() -> void:
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()
	
func _on_player_stats_changed() -> void:
	unit_resource.text = str(player_stats.resource)
