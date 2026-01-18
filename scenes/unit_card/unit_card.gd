class_name UnitCard
extends Button

signal unit_bought(unit: UnitStats)

const HOVER_BORDER_COLOR := Color("fafa82")
const NO_RESOURCE_COLOR := Color.CRIMSON
const RESOURCE_AVAILABLE_COLOR = Color("ffffff")

@export var player_stats: PlayerStats
@export var unit_stats: UnitStats : set = _set_unit_stats

@onready var resource_color: Panel = %ResourceColor
@onready var resource_cost: Label = %ResourceCost
@onready var unit_image: TextureRect = %UnitImage
@onready var unit_count: Label = %UnitCount
@onready var border: Panel = %Border
@onready var unit_name: Label = %UnitName
@onready var border_sb: StyleBoxFlat = border.get_theme_stylebox("panel")
@onready var resource_sb: StyleBoxFlat = resource_color.get_theme_stylebox("panel")

var border_color: Color
var unit_pool: UnitPool

func _ready() -> void:
	unit_pool = player_stats.unit_pool
	unit_pool.unit_count_adjusted.connect(_on_player_stats_changed)
	player_stats.changed.connect(_on_player_stats_changed)
	_on_player_stats_changed()

func _set_unit_stats(value: UnitStats) -> void:
	unit_stats = value
	
	if not is_node_ready():
		await ready
		
	if not unit_stats:
		disabled = true
		return
	
	border_color = UnitStats.RARITY_COLORS[unit_stats.rarity]
	border_sb.border_color = border_color
	resource_sb.bg_color = border_color
	unit_name.text = unit_stats.name
	unit_count.text = str(unit_pool.get_current_unit_count(unit_stats))
	resource_cost.text = str(unit_stats.resource_cost)
	unit_image.texture.atlas = unit_stats.icon_texture
	
func _on_player_stats_changed() -> void:
	if not unit_stats:
		return
	
	unit_count.text = str(unit_pool.get_current_unit_count(unit_stats))
	var has_enough_resource := player_stats.resource >= unit_stats.resource_cost
	disabled = not has_enough_resource
	
	if not has_enough_resource:
		resource_cost.label_settings.font_color = NO_RESOURCE_COLOR
	elif resource_cost.label_settings.font_color != RESOURCE_AVAILABLE_COLOR:
		resource_cost.label_settings.font_color = RESOURCE_AVAILABLE_COLOR
	
	if _no_more_units() or not has_enough_resource:
		# Grey it out
		modulate = Color(Color.WHITE, 0.5)
	else:
		modulate = Color(Color.WHITE, 1.0)
		

func _on_pressed() -> void:
	if _no_more_units():
		return
	
	# TODO: We could probably change the purchase unit to decrement resource
	# in its own method
	unit_pool.purchase_unit(unit_stats)
	player_stats.resource -= unit_stats.resource_cost
	unit_bought.emit(unit_stats)

func _on_mouse_entered() -> void:
	if not disabled:
		border_sb.border_color = HOVER_BORDER_COLOR

func _on_mouse_exited() -> void:
	border_sb.border_color = border_color

func _no_more_units() -> bool:
	return unit_pool.no_available_unit(unit_stats)
