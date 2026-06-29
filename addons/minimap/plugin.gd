@tool
extends EditorPlugin

func _enter_tree() -> void:
	# Using absolute paths so Godot can never lose track of the files
	var script = preload("res://addons/minimap/mini_map.gd")
	var icon = preload("res://addons/minimap/icon.svg")
	
	add_custom_type("MiniMap", "Panel", script, icon)

func _exit_tree() -> void:
	remove_custom_type("MiniMap")
