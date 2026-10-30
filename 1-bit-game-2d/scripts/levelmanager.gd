extends Node

const SAVE_PATH = "user://level_data.save"

var levels: Dictionary = {
	"1": "res://scenes/levels/level_1.tscn",
	"2": "res://scenes/levels/level_2.tscn",
	"3": "res://scenes/levels/level_3.tscn",
	"4": "res://scenes/levels/level_4.tscn",
	"5": "res://scenes/levels/level_5.tscn",
}

# Default starting level must be a String "1"
var unlocked_levels: Array = ["1"]

func _ready() -> void:
	load_progress()

func load_level(level_id: String) -> void:
	# Ensure level ID exists and is unlocked
	if levels.has(level_id) and is_level_unlocked(level_id):
		get_tree().change_scene_to_file(levels[level_id])
	else:
		print("Level ", level_id, " is locked or invalid!")

func is_level_unlocked(level_id: String) -> bool:
	return unlocked_levels.has(str(level_id))

func unlock_level(level_id: String) -> void:
	var id_str = str(level_id)
	if not unlocked_levels.has(id_str):
		unlocked_levels.append(id_str)
		save_progress()

func save_progress() -> void:
	var config = ConfigFile.new()
	config.set_value("Progress", "unlocked_levels", unlocked_levels)
	config.save(SAVE_PATH)

func load_progress() -> void:
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		unlocked_levels = config.get_value("Progress", "unlocked_levels", ["1"])
