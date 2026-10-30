extends Area2D

@export_category("Movement Settings")
## Enable if this hazard moves back and forth
@export var moves: bool = false
## Movement direction vector (e.g., Vector2(1, 0) for horizontal, Vector2(0, 1) for vertical)
@export var move_direction: Vector2 = Vector2.RIGHT
## Speed of movement in pixels per second
@export var speed: float = 50.0
## Distance to travel in pixels before reversing direction
@export var move_distance: float = 100.0

var start_position: Vector2
var moving_forward: bool = true

func _ready() -> void:
	start_position = global_position
	# Automatically connect the body_entered signal
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if moves:
		_handle_movement(delta)

func _handle_movement(delta: float) -> void:
	var target_vector = move_direction.normalized() * move_distance
	var target_position = start_position + target_vector if moving_forward else start_position

	global_position = global_position.move_toward(target_position, speed * delta)

	# Reverse direction upon reaching the target distance
	if global_position.distance_to(target_position) < 1.0:
		moving_forward = !moving_forward
		
		# Flip sprite horizontally if moving left/right
		var sprite = get_node_or_null("Sprite2D") or get_node_or_null("AnimatedSprite2D")
		if sprite and move_direction.x != 0:
			sprite.flip_h = !moving_forward if move_direction.x > 0 else moving_forward

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("player"):
		if body.has_method("die"):
			body.die()
