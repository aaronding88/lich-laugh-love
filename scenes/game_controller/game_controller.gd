class_name GameController
extends Node

@export var battle_view: DungeonRoom
@export var dungeon_map: DungeonMap

func _ready():
	# Hide the battle view on start
	dungeon_map._pause_and_hide()
	dungeon_map.process_mode = PROCESS_MODE_DISABLED
	battle_view.connect(_on_dungeon_map_pressed)
	# TODO: We wanna connect the battle_view's signal

func _on_dungeon_map_pressed():
	battle_view._pause_and_hide()
	battle_view.process_mode = PROCESS_MODE_DISABLED
	
	dungeon_map._resume_and_show()
	dungeon_map.process_mode = PROCESS_MODE_DISABLED
	
