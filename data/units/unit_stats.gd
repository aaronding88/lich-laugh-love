class_name UnitStats
extends Resource

# Not using rarity initially, but we may do it depending on game design later
enum _RARITY {COMMON, UNCOMMON, RARE, LEGENDARY}

@export var name: String

@export_category("Date")
@export var resource_cost := 1

@export_category("Visuals")
@export var unit_model: SpriteFrames
@export var unit_texture: Texture2D
@export var spritesheet: bool

func _to_string() -> String:
	return name
