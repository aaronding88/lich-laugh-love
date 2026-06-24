class_name GameController
extends Node

@export var battle_view: DungeonRoom
@export var dungeon_map: DungeonMap

func _ready():
	# Hide the battle view on start
	dungeon_map._pause_and_hide()
	dungeon_map.process_mode = PROCESS_MODE_DISABLED
	
	# binds
	battle_view.dungeon_map_button.dungeon_map_button_pressed.connect(_on_dungeon_map_pressed)
	dungeon_map.battle_map_button.battle_view_button_pressed.connect(_on_battle_view_pressed)

func _on_dungeon_map_pressed():
	battle_view._pause_and_hide()
	dungeon_map._resume_and_show()
	
func _on_battle_view_pressed():
	dungeon_map._pause_and_hide()
	battle_view._resume_and_show()
	
