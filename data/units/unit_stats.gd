class_name UnitStats
extends Resource

enum RARITY {COMMON, UNCOMMON, RARE, LEGENDARY}
enum Team {PLAYER, ENEMY}

signal health_reached_zero
signal fatigue_bar_filled

const RARITY_COLORS := {
	RARITY.COMMON: Color("027000"),
	RARITY.UNCOMMON: Color("1c527c"),
	RARITY.RARE: Color("ab0979"),
	RARITY.LEGENDARY: Color("ea940b")
}

const TARGET := {
	Team.PLAYER: "enemy_units",
	Team.ENEMY: "player_units"
}

const Z_INDEX := 1
const MOVE_ONE_TILE_SPEED := 1.0
const MAX_ATTACK_RANGE := 150
const FATIGUE_PER_ATTACK := 1

@export var name: String

@export_category("Date")
@export var resource_cost := 1
@export var rarity: RARITY
@export var unit_count := 10

@export_category("Visuals")
@export var unit_texture: Texture2D
@export var icon_texture: Texture2D
@export var sprite_frames: SpriteFrames
@export var spritesheet_size: Vector2i

@export_category("Battle")
@export var team: Team
@export var max_health: int
@export var max_fatigue: int
@export var attack_damage: int
@export var attack_speed: float # Attacks per one second
@export var armor: int
@export var magic_resist: int
@export var attack_range: int
@export var melee_attack: PackedScene = preload("res://scenes/_effects/attack_smear_effect.tscn")
@export var ranged_attack: PackedScene
@export var ability: PackedScene
@export var auto_attack_sound: AudioStream

var health: int : set = _set_health
var fatigue: int : set = _set_fatigue

func reset_health() -> void:
	health = max_health
	
func reset_fatigue() -> void:
	fatigue = 0
	
func get_attack_damage() -> int:
	return attack_damage
	
func get_time_between_attacks() -> float:
	return 1.0 / attack_speed
	
func is_melee() -> bool:
	return attack_range <= 128
	
func _set_health(value: int) -> void:
	health = value
	emit_changed()
	
	if health <= 0:
		health_reached_zero.emit()
		
func _set_fatigue(value: int) -> void:
	fatigue = value
	emit_changed()
	
	if fatigue >= max_fatigue and max_fatigue > 0:
		fatigue_bar_filled.emit()

func _to_string() -> String:
	return name
