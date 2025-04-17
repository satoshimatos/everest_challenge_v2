extends StaticBody2D

@onready var rock_particles: CPUParticles2D = $CPUParticles2D
@export var key_enemies: Array[CharacterBody2D]
var is_active: bool = false

func _process(delta: float) -> void:
	var all_invalid = true

	for enemy in key_enemies:
		if is_instance_valid(enemy):
			all_invalid = false
			break

	if all_invalid and not is_active:
		remove_rock()

func remove_rock():
	is_active = true
	rock_particles.emitting = true
	AudioManager.play("rocks_stream_down")
	var original_position = position
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", Vector2(original_position.x, original_position.y + 300), 10)
	# Return to original position
	await tween.finished
	queue_free()
