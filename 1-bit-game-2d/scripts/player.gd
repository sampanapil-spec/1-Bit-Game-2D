extends CharacterBody2D

const SPEED = 250.0
const JUMP_VELOCITY = -350.0

@onready var jump_sfx: AudioStreamPlayer = get_node_or_null("AudioStreamPlayer")
@onready var animated_sprite: AnimatedSprite2D = get_node_or_null("AnimatedSprite2D")

var gems_collected: int = 0
var can_double_jump: bool = false
var is_dead: bool = false

func _physics_process(delta: float) -> void:
	# Ignore movement input if dead
	if is_dead:
		return

	if not is_on_floor():
		velocity += get_gravity() * delta

	# Double jump is available whenever at least one gem charge is held
	can_double_jump = gems_collected > 0

	# Jump and Double Jump Input Logic
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			perform_jump()
		elif can_double_jump:
			perform_jump()
			gems_collected -= 1  # Consume one gem charge
			ScoreManager.set_double_jumps(gems_collected)  # Update the HUD
			can_double_jump = gems_collected > 0

	var direction = Input.get_axis("left", "right")

	# Sprite Animation & Horizontal Flipping
	if animated_sprite:
		if direction > 0:
			animated_sprite.flip_h = false
		elif direction < 0:
			animated_sprite.flip_h = true

		if not is_on_floor():
			animated_sprite.play("jump")
		elif direction != 0:
			animated_sprite.play("walk")
		else:
			animated_sprite.play("idle")

	# Movement Calculations
	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func perform_jump() -> void:
	velocity.y = JUMP_VELOCITY
	if jump_sfx:
		jump_sfx.play()

func collect_gem() -> void:
	# Cap stored double jumps at 10 and tell the HUD
	gems_collected = mini(gems_collected + 1, ScoreManager.MAX_DOUBLE_JUMPS)
	can_double_jump = true
	ScoreManager.set_double_jumps(gems_collected)

func die() -> void:
	if is_dead:
		return

	is_dead = true

	# Stop physics processing and zero out velocity
	set_physics_process(false)
	velocity = Vector2.ZERO

	# Create full-screen death transition overlay
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	get_tree().current_scene.add_child(canvas_layer)

	var rect = ColorRect.new()
	rect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	rect.color = Color(0, 0, 0, 0) # Start transparent
	canvas_layer.add_child(rect)

	# Smoothly fade to black upon death
	var tween = create_tween()
	tween.tween_property(rect, "color:a", 1.0, 0.4)
	await tween.finished

	# Reload current level to respawn
	get_tree().reload_current_scene()
