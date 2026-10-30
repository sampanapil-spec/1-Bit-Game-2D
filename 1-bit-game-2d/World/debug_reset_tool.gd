extends Node

## Developer/Owner Debug Reset Tool
## Attach this script to a node in your Main Menu or Level Select scene.
## Features are strictly restricted to debug builds (Editor / F5 mode).

@export_category("Owner Access Controls")
## Set key shortcut for owner reset (Default: F9)
@export var owner_reset_key: Key = KEY_F9

func _unhandled_input(event: InputEvent) -> void:
	# GUARD: Only allow code execution if running in debug mode (Editor / Dev Builds)
	if not OS.is_debug_build():
		return

	# Trigger reset when owner presses designated key (F9)
	if event is InputEventKey and event.pressed and event.keycode == owner_reset_key:
		execute_owner_reset()

func execute_owner_reset() -> void:
	const SAVE_PATH = "user://level_data.save"
	
	# 1. Erase save file completely from disk
	if FileAccess.file_exists(SAVE_PATH):
		var dir = DirAccess.open("user://")
		if dir:
			dir.remove("level_data.save")
			print("[OWNER TOOL] Save file 'level_data.save' deleted successfully.")

	# 2. Reset LevelManager internal state if loaded
	if Engine.has_singleton("LevelManager") or get_node_or_null("/root/LevelManager"):
		var level_mgr = get_node_or_null("/root/LevelManager")
		if level_mgr and "unlocked_levels" in level_mgr:
			level_mgr.unlocked_levels = ["1"]
			print("[OWNER TOOL] LevelManager memory state reset to Level 1.")

	# 3. Reload current scene to refresh UI buttons instantly
	get_tree().reload_current_scene()
