class_name DungeonMap
extends Node2D

@export var ui_layer: CanvasLayer

func _pause_and_hide():
	hide()
	ui_layer.hide()
	process_mode = PROCESS_MODE_DISABLED

func _resume_and_show():
	show()
	ui_layer.show()
	process_mode = PROCESS_MODE_INHERIT
