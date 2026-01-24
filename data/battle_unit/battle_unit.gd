class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var animated_skin: AnimatedSprite2D = $AnimatedSkin
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree


var velocity := Vector2.ZERO
	
func _physics_process(_delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		velocity.y += 1
	if Input.is_action_pressed("ui_down"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1

	if velocity == Vector2.ZERO:
		animation_tree.get("parameters/playback").travel("idle")
	else:
		animation_tree.get("parameters/playback").travel("running")
		animation_tree.set("parameters/idle/blend_position", velocity)
		animation_tree.set("parameters/running/blend_position", velocity)
	
func _input(input: InputEvent) -> void:
	if input.is_action_pressed("ui_down"):
		animation_player.play("run_down")
	if input.is_action_released("ui_down"):
		animation_player.play("idle")

func set_stats(value: UnitStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready

	if not stats:
		return
		
	stats = value.duplicate()
	collision_layer = stats.team + 1
	
	animated_skin.sprite_frames = stats.sprite_frames
		 
