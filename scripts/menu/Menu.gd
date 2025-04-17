extends Control

@onready var color_rect: ColorRect = $ColorRect
@onready var play_btn: Button = $MarginContainer/VBoxContainer/Play
@onready var options_btn: Button = $MarginContainer/VBoxContainer/Options
@onready var quit_btn: Button = $MarginContainer/VBoxContainer/Quit
@onready var options_scene = preload("res://scenes/maps/Options.tscn").instantiate()

func _ready() -> void:
	options_scene.visible = false
	add_child(options_scene)
	retranslate()
	Translator.LanguageChanged.connect(retranslate)

func _on_play_pressed() -> void:
	AudioManager.play("start_game")
	color_rect.z_index = 10
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate", Color(1, 1, 1, 1), 0.05)
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 0), 0.05)
	tween.tween_property(color_rect, "modulate", Color(0, 0, 0, 1), 1.5)
	tween.set_ease(Tween.EASE_OUT)
	await tween.finished
	get_tree().change_scene_to_file("res://scenes/maps/forest_1.tscn")

func _on_options_pressed() -> void:
	AudioManager.play("select")
	options_scene.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()

func retranslate():
	play_btn.text = Translator.translate("Start")
	options_btn.text = Translator.translate("Options")
	quit_btn.text = Translator.translate("Quit")
