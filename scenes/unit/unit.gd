@tool
class_name Unit
extends Area2D

signal quick_sell_pressed

const tile_size: Vector2 = Vector2(256, 128) # This should be tile size in px

@export var stats: UnitStats : set = _set_stats

@onready var body: AnimatedSprite2D = $Visuals/Body
@onready var shadow: AnimatedSprite2D = $Visuals/Body/Shadow
@onready var placeholder: Sprite2D = $Visuals/Placeholder
@onready var health_bar: ProgressBar = $HealthBar
@onready var fatigue_bar: ProgressBar = $FatigueBar

@onready var drag_and_drop: DragAndDrop = $DragAndDrop
@onready var outline_highlighter: OutlineHighlighter = $OutlineHighlighter

var is_hovered := false

func _ready() -> void:
	if not Engine.is_editor_hint():
		drag_and_drop.drag_canceled.connect(_on_drag_canceled)
		drag_and_drop.dropped.connect(_on_dropped)
		

func _input(event: InputEvent) -> void:
	if not is_hovered:
		return
	
	if event.is_action_pressed("quick_sell"):
		quick_sell_pressed.emit()

func _set_stats(value: UnitStats) -> void:
	stats = value
	
	if value == null:
		return
		
	if not is_node_ready():
		await ready
		
	placeholder.texture = value.unit_texture
	placeholder.region_rect.position = Vector2(0, 0)
 		
func reset_after_dragging(starting_position: Vector2) -> void:
	global_position = starting_position
	
func _on_drag_canceled(starting_position: Vector2) -> void:
	reset_after_dragging(starting_position)
	
func _on_dropped(_starting_position) -> void:
	#global_position = drag_and_drop.snap_iso(position, tile_size)\
	pass

func _on_mouse_entered() -> void:
	if drag_and_drop.dragging:
		return
		
	is_hovered = true
	outline_highlighter.highlight()

func _on_mouse_exited() -> void:
	
	if drag_and_drop.dragging:
		return
	
	is_hovered = false
	outline_highlighter.clear_highlight()
