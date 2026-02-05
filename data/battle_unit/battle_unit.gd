class_name BattleUnit
extends Area2D

@export var stats: UnitStats: set = set_stats

@onready var animated_skin: AnimatedSprite2D = $AnimatedSkin
@onready var hurt_box: HurtBox = $HurtBox
@onready var detect_range: DetectRange = $DetectRange
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar
@onready var attack_timer: Timer = $AttackTimer
@onready var melee_attack: Attack = $MeleeAttack
@onready var unit_ai: UnitAI = $UnitAI
@onready var target_finder: TargetFinder = $TargetFinder
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree


func _ready() -> void:
	hurt_box.hurt.connect(_on_hurt)
	
func _input(event: InputEvent) -> void:
	if event.is_action("test1") and stats and stats.is_melee():
		melee_attack.attack(Vector2.ZERO)

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
	animation_tree.get("parameters/playback").travel(animation_name)
	animation_tree.set("parameters/idle/blend_position", Vector2(velocity))
	animation_tree.set("parameters/running/blend_position", Vector2(velocity))
	animation_tree.set("parameters/attack/blend_position", Vector2(velocity))
	
	
func _on_hurt(damage: int) -> void:
	print("hurt!")
	stats.health -= damage

func _on_death() -> void:
	print(stats.name, " dies!")
	queue_free()
