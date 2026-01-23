class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var animated_skin: AnimatedSprite2D = $AnimatedSkin
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar

func set_stats(value: UnitStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready

	if not stats:
		return
		
	stats = value.duplicate()
	collision_layer = stats.team + 1
	
	animated_skin.sprite_frames = stats.sprite_frames
	animated_skin.play()
		 
