extends Node

@onready var available_players_list: Array = get_tree().get_nodes_in_group("AudioPlayers")
@onready var audio_player_prefab: PackedScene = preload("res://scenes/prefabs/global/AudioPlayer.tscn")

var busy_players_list: Array = []
var audio_repository: Dictionary
var directory_path = "res://assets/audio"
var global_volume: float = 50

const AVAILABLE_AUDIO_PLAYERS = 30

func _ready() -> void:
	var audio_files = [
		"res://assets/audio/combat/heavy_swing.wav",
		"res://assets/audio/combat/medium_swing.wav",
		"res://assets/audio/combat/player_hit1.wav",
		"res://assets/audio/combat/stab_weak.wav",
		"res://assets/audio/combat/whoosh2.wav",
		"res://assets/audio/enemies/grunt1.wav",
		"res://assets/audio/enemies/grunt2.wav",
		"res://assets/audio/general/death_sound1.wav",
		"res://assets/audio/general/death_sound2.wav",
		"res://assets/audio/general/rocks_stream_down.wav",
		"res://assets/audio/general/select.wav",
		"res://assets/audio/general/start_game.wav",
		"res://assets/audio/general/victory1.wav",
	]
	load_audio_files(audio_files)
	
	instantiate_players()

func get_global_volume():
	return global_volume

func set_global_volume(new_value: float):
	global_volume = new_value

func play(audio_name: String, configs: Dictionary = {}):
	if available_players_list.size() == 0:
		busy_players_list[0]._force_availability()
	var player = available_players_list[0]  # Get the first available player
	var property_names = []
	for p in player.get_property_list():
		property_names.append(p.name)
	for config in configs:
		if config in property_names:
			player.set(config, configs[config])
	player.volume_db = percentage_to_db(global_volume)
	if get_global_volume() > 0:
		available_players_list[0]._play(audio_name)
			
# Recursively scans the directory for all .wav files
func get_all_wav_files_in_directory(path: String) -> Array:
	var files = []
	var dir = DirAccess.open(path)

	if dir and dir.list_dir_begin() == OK:
		var file_name = dir.get_next()

		while file_name != "":
			var full_path = path + "/" + file_name
			
			if dir.current_is_dir():
				# Recursively scan subdirectories
				files.append_array(get_all_wav_files_in_directory(full_path))
			elif file_name.ends_with(".wav"):  
				files.append(full_path)  # Store the full path of .wav files
				
			file_name = dir.get_next()

		dir.list_dir_end()
	else:
		print("Failed to open directory: " + path)

	return files

# Preload all audio files into the dictionary
func load_audio_files(files_list: Array):
	for file in files_list:
		var audio_name = file.get_file().trim_suffix(".wav")  # Extract file name without extension
		audio_repository[audio_name] = load(file)  # Load and store in dictionary

func instantiate_players():
	for i in range(0, AVAILABLE_AUDIO_PLAYERS):
		var audio_player_instance = audio_player_prefab.instantiate()
		self.add_child(audio_player_instance)
		available_players_list.append(audio_player_instance)

func percentage_to_db(slider_value: float) -> float:
	if slider_value <= 50:
		return lerp(-30.0, 0.0, slider_value / 50.0)
	else:
		return lerp(0.0, 4.0, (slider_value - 50.0) / 50.0)
