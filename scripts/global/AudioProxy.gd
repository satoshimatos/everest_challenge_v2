extends Node

func play(filename: String, config: Dictionary = {}):
	AudioManager.play(filename, config)
