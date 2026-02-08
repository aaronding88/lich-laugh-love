class_name BattleUnit
extends Area2D

signal unit_died

@export var stats: UnitStats: set = set_stats

@onready var unit_body: CollisionShape2D = $CollisionShape2D
@onready var animated_skin: AnimatedSprite2D = $AnimatedSkin
@onready var hurt_box: HurtBox = $HurtBox
@onready var detect_range: DetectRange = $DetectRange
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar
@onready var attack_speed_timer_label: Label = %AttackSpeedTimerDebug
@onready var attack_timer: Timer = $AttackTimer
@onready var windup_timer: Timer = $WindupTimer
@onready var melee_attack: Attack = $MeleeAttack
@onready var unit_ai: UnitAI = $UnitAI
@onready var target_finder: TargetFinder = $TargetFinder
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree

var is_dead := false

func _process(_delta: float) -> void:
	# DEBUG CODE
	if unit_ai.fsm.state is AutoAttackState:
		attack_speed_timer_label.text = str(attack_timer.time_left).pad_decimals(1)
	else:
		attack_speed_timer_label.text = ""

func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)

func set_stats(value: UnitStats) -> void:
	stats = value
	
	if not is_node_ready():
		await ready

	if not stats:
		return
		
	stats = value.duplicate()
	stats.reset_health()
	collision_layer = stats.team + 1
	hurt_box.collision_layer = stats.team + 1
	hurt_box.collision_mask = 2 - stats.team
	detect_range.stats = stats
	health_bar.stats = stats
	fatigue_bar.stats = stats
	
	melee_attack.spawner.scene = stats.melee_attack
	
	animated_skin.sprite_frames = stats.sprite_frames
	stats.health_reached_zero.connect(_on_death)
	
func set_animation(animation_name: String, velocity = Vector2.ZERO) -> void:
	# Reset animation if it's in it
	if animation_tree.get("parameters/playback").get_current_node() == animation_name:
		animation_tree.get("parameters/playback").start(animation_name)	
	else:
		animation_tree.get("parameters/playback").travel(animation_name)	
	animation_tree.set("parameters/idle/blend_position", Vector2(velocity))
	animation_tree.set("parameters/running/blend_position", Vector2(velocity))
	animation_tree.set("parameters/attack/attack_animation/blend_position", Vector2(velocity))
	

# Currently this assumes the attack animation is 1 second, if it's longer we'll
# want to calculated it accordingly
func set_animation_speed(playtime: float) -> void:
	animation_tree.set("parameters/attack/time_scale/scale", playtime)
	
func _on_hurt(damage: int) -> void:
	stats.health -= damage

func _on_death() -> void:
	animation_tree.get("parameters/playback").travel("death")
	
	# Should create a reusable "set dead" function, if needed
	health_bar.hide()
	fatigue_bar.hide()
	is_dead = true
	unit_body.set_deferred("disabled", true)
	hurt_box.collision_layer = 0
	hurt_box.collision_mask = 0
	if stats.team == stats.Team.PLAYER:
		add_to_group("player_dead_units")	
		remove_from_group("player_units")
	else:
		add_to_group("enemy_dead_units")
		remove_from_group("enemy_units")
	unit_died.emit()
