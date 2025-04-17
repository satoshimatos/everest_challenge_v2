extends Control

@onready var language_label: Label = $MarginContainer/VBoxContainer/Language/Label
@onready var volume_label: Label = $MarginContainer/VBoxContainer/Volume/CenterContainer/Label
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/Volume/CenterContainer2/VolumeSlider
@onready var back_btn: Button = $MarginContainer/VBoxContainer/Back
@onready var lang_option_button = $MarginContainer/VBoxContainer/Language/OptionButton

func _ready() -> void:
	retranslate()
	Translator.LanguageChanged.connect(retranslate)
	populate_language_selection()
	set_volume_slider()

func _on_back_pressed() -> void:
	AudioManager.play("select")
	get_tree().change_scene_to_file("res://scenes/maps/Menu.tscn")

func populate_language_selection():
	var i = 0
	for language in Translator.get_available_languages():
		lang_option_button.add_item(Translator.translate(language), i)
		i += 1
	select_option(Translator.selected_language)

func set_volume_slider():
	volume_slider.value = AudioManager.get_global_volume()

func select_option(target_text: String):
	var id = Translator.get_available_languages().find(Translator.get_language())
	lang_option_button.select(id)

func _on_option_button_item_selected(index: int) -> void:
	Translator.set_language(Translator.get_available_languages()[lang_option_button.get_selected_id()])

func retranslate():
	language_label.text = Translator.translate("Language")
	volume_label.text = Translator.translate("Volume")
	back_btn.text = Translator.translate("Back")

func _on_volume_slider_drag_ended(value_changed: bool) -> void:
	AudioManager.set_global_volume(volume_slider.value)
	
