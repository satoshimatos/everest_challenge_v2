extends Node

var stats: Dictionary

func _ready() -> void:
	stats = {
		"hp": 50,
		"stamina": 30,
		"stamina_regen": 0.25,
		"attack": 5.0,
		"move_speed": 100.0,
		"defense": 1.0,
		"invulnerability_time": 2.0,
	}
