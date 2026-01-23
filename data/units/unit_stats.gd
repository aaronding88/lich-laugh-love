class_name UnitStats
extends Resource

enum RARITY {COMMON, UNCOMMON, RARE, LEGENDARY}
enum Team {PLAYER, ENEMY}



const RARITY_COLORS := {
	RARITY.COMMON: Color("027000"),
	RARITY.UNCOMMON: Color("1c527c"),
	RARITY.RARE: Color("ab0979"),
	RARITY.LEGENDARY: Color("ea940b")
}

const Z_INDEX := 1

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

func _to_string() -> String:
	return name
