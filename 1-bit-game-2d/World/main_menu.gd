extends Node2D


func _on_start_button_pressed() -> void:
	# Clean direct change to Level 1 — no flash overlay!
	get_tree().change_scene_to_file("res://World/level_select.tscn")


func _on_quit_button_pressed() -> void:
	# Quits the application (Note: Web exports automatically ignore/hide quit)
	get_tree().quit()


func _on_full_screen_button_pressed() -> void:
	# Toggle between Fullscreen and Windowed mode
	var current_mode = DisplayServer.window_get_mode()
	if current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)


func _ready() -> void:
	# Stop level music when entering Main Menu
	MusicManager.stop_music()
	
	if OS.get_name() == "Web":
		$VBoxContainer/QuitButton.hide()
