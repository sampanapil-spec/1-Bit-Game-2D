extends Node

signal score_updated(new_score: int)
signal double_jumps_updated(new_count: int)

const MAX_DOUBLE_JUMPS := 10

var total_score: int = 0
var double_jumps: int = 0

func add_score(amount: int) -> void:
	total_score += amount
	score_updated.emit(total_score)

func set_double_jumps(count: int) -> void:
	double_jumps = clampi(count, 0, MAX_DOUBLE_JUMPS)
	double_jumps_updated.emit(double_jumps)

func reset_score() -> void:
	total_score = 0
	double_jumps = 0
	score_updated.emit(total_score)
	double_jumps_updated.emit(double_jumps)
