extends CanvasLayer

@onready var score_label: Label = $MarginContainer/HBoxContainer/ScoreLabel
@onready var jumps_label: Label = $MarginContainer/HBoxContainer/JumpsLabel

func _ready() -> void:
	ScoreManager.score_updated.connect(_on_score_updated)
	ScoreManager.double_jumps_updated.connect(_on_jumps_updated)
	_on_score_updated(ScoreManager.total_score)
	_on_jumps_updated(ScoreManager.double_jumps)

func _on_score_updated(value: int) -> void:
	score_label.text = "SCORE: %d" % value

func _on_jumps_updated(value: int) -> void:
	jumps_label.text = "JUMPS: %d/%d" % [value, ScoreManager.MAX_DOUBLE_JUMPS]
