extends Button

@export var level_id: String = "1"

func _ready() -> void:
	text = "Level " + level_id
	
	# Clean up previous connections if instanced multiple times
	if pressed.is_connected(_on_pressed):
		pressed.disconnect(_on_pressed)
	pressed.connect(_on_pressed)

	# Update button interactivity based on saved progress
	update_button_state()

func update_button_state() -> void:
	if LevelManager.is_level_unlocked(level_id):
		disabled = false
		modulate = Color(1, 1, 1, 1) # Normal appearance
	else:
		disabled = true
		modulate = Color(0.4, 0.4, 0.4, 0.7) # Dimmed & unclickable

func _on_pressed() -> void:
	LevelManager.load_level(level_id)
