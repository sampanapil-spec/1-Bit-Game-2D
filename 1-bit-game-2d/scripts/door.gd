extends Area2D

## Assign the ID of the level this door unlocks (e.g., "2", "3")
@export var target_level_id: String = ""

var is_transitioning: bool = false

func _ready() -> void:
	# Automatically connect body_entered signal if not connected in the Inspector
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Ignore non-player physics bodies (like TileMaps or enemies) and prevent double triggers
	if (body.name == "Player" or body.is_in_group("player")) and not is_transitioning:
		if target_level_id != "":
			is_transitioning = true
			
			# Freeze player physics and movement
			if body.has_method("set_physics_process"):
				body.set_physics_process(false)

			# Create dynamic overlay canvas above all game layers
			var canvas_layer = CanvasLayer.new()
			canvas_layer.layer = 100
			get_tree().current_scene.add_child(canvas_layer)

			var rect = ColorRect.new()
			rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
			# Start fully transparent light-gray
			rect.color = Color(0.8, 0.8, 0.8, 0.0)
			canvas_layer.add_child(rect)

			# Fade to 60% opacity soft light-gray (eye-friendly flash)
			var tween = create_tween()
			tween.tween_property(rect, "color", Color(0.8, 0.8, 0.8, 0.6), 0.3)
			await tween.finished

			# Clean up overlay before changing scenes to prevent screen bleed
			canvas_layer.queue_free()

			# Unlock the next level progress
			LevelManager.unlock_level(target_level_id)
			
			# Send player to the Level Select menu so they can choose the next level
			get_tree().change_scene_to_file("res://World/level_select.tscn")
		else:
			print("Warning: No target_level_id assigned to this door!")
