extends State

class_name Die

@export var enemy: CharacterBody2D

var anim_player: AnimationPlayer
var fade_out_timer: int = 5

func enter():
	AudioManager.play("grunt2")
	enemy.gravity = 0
	enemy.get_node("CollisionShape2D").disabled = true
	enemy.velocity.x = 0
	anim_player = enemy.get_node("AnimationPlayer")
	anim_player.stop()
	if anim_player.animation_finished.is_connected(_on_animation_finished):
		anim_player.animation_finished.disconnect(_on_animation_finished)
	anim_player.animation_finished.connect(_on_animation_finished)
	if anim_player.has_animation("death"):
		anim_player.play("death")
	if (enemy.state_label):
		update_state_label(enemy.state_label, self.name)

func _on_animation_finished(_anim_name: String) -> void:
	var tween = create_tween()
	tween.tween_property(enemy.sprite, "modulate", Color(1, 1, 1, 0), fade_out_timer)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_callback(enemy.queue_free)
