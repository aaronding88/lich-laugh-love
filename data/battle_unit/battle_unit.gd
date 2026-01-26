class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var animated_skin: AnimatedSprite2D = $AnimatedSkin
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var unit_ai: UnitAI = $UnitAI


func set_stats(value: UnitStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready

	if not stats:
		return
		
	stats = value.duplicate()
	collision_layer = stats.team + 1
	
	animated_skin.sprite_frames = stats.sprite_frames
	
func set_animation(animation_name: String, velocity = Vector2.ZERO) -> void:
	animation_tree.get("parameters/playback").travel(animation_name)
	animation_tree.set("parameters/idle/blend_position", Vector2(velocity))
	animation_tree.set("parameters/running/blend_position", Vector2(velocity))
	
func face(direction_to_face: Vector2) -> void:
	# There must be a way to set every parameter
	var test := Vector2(0, 1)
	animation_tree.set("parameters/idle/blend_position", Vector2(test))
	animation_tree.set("parameters/running/blend_position", Vector2(test))

	
