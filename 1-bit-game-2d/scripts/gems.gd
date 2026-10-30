extends Area2D

@export var point_value: int = 1
## Assign your gem pickup WAV/OGG file here in the Inspector
@export var pickup_sfx: AudioStream

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		# Play audio at gem location before destroying node
		_play_pickup_sfx()

		# Grant double jump charge to player
		if body.has_method("collect_gem"):
			body.collect_gem()
			
		# Update global score
		if get_node_or_null("/root/ScoreManager"):
			ScoreManager.add_score(point_value)
			
		queue_free()

func _play_pickup_sfx() -> void:
	if pickup_sfx:
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = pickup_sfx
		audio_player.global_position = global_position
		# Auto-free the audio node when the sound finishes playing
		audio_player.finished.connect(audio_player.queue_free)
		
		get_tree().current_scene.add_child(audio_player)
		audio_player.play()
