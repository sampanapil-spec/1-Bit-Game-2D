extends Node2D

func _ready() -> void:
	MusicManager.play_music()
	ScoreManager.reset_score()

	# Create screen-wide fade in overlay
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	add_child(canvas_layer)

	var rect = ColorRect.new()
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.color = Color(1, 1, 1, 1) # Start solid white
	canvas_layer.add_child(rect)

	# Fade from solid white (1) to transparent (0)
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 0.0, 0.3)
	await tween.finished
	
	canvas_layer.queue_free() # Clean up overlay node
