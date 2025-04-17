extends Node

@export var key_enemies: Array[CharacterBody2D]

func _process(delta: float) -> void:
	var all_invalid = true

	for enemy in key_enemies:
		if is_instance_valid(enemy):
			all_invalid = false
			break

	if all_invalid:
		get_tree().change_scene_to_file("res://scenes/misc/Victory.tscn")
