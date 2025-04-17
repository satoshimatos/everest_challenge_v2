extends Control

@onready var player: Player = $Player
@onready var label: Label = $CenterContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play("death_sound1")
	label.text = ""
	player._death_screen()

func _on_timer_timeout() -> void:
	type_text(Translator.translate("You died"))
	
func type_text(full_text: String, delay := 0.1):
	for i in full_text.length():
		label.text += full_text[i]
		await get_tree().create_timer(delay).timeout
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(player, "modulate", Color(1, 1, 1, 0), 2)
	tween.parallel().tween_property(label, "modulate", Color(1, 1, 1, 0), 2)
	tween.set_ease(Tween.EASE_OUT)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/maps/Menu.tscn")
