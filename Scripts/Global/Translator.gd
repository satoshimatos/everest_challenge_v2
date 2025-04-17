extends Node

signal LanguageChanged

var entries: Dictionary = {
	"Start": {
		"Portuguese": "Iniciar",
		"French": "Démarrer"
	},
	"Options": {
		"Portuguese": "Opções",
		"French": "Options"
	},
	"Quit": {
		"Portuguese": "Sair",
		"French": "Quitter"
	},
	"Back": {
		"Portuguese": "Voltar",
		"French": "Retour"
	},
	"Volume": {
		"Portuguese": "Volume",
		"French": "Volume"
	},
	"Language": {
		"Portuguese": "Língua",
		"French": "Langue"
	},
	"English": {
		"Portuguese": "Inglês",
		"French": "Anglais"
	},
	"Portuguese": {
		"Portuguese": "Português",
		"French": "Portugais"
	},
	"French": {
		"Portuguese": "Francês",
		"French": "Français"
	},
}

var words: Array[String] = [
]

var languages: Array[String] = [
	"English",
	"French",
	"Portuguese",
]

var selected_language: String = "English"

func get_available_languages():
	return languages
	
func set_language(language: String):
	selected_language = language
	LanguageChanged.emit()

func get_language() -> String:
	return selected_language
	
func translate(english_word: String) -> String:
	if selected_language == "English":
		return english_word
	return entries[english_word][selected_language]
