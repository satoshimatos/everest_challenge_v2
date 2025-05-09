extends AudioStreamPlayer2D

@onready var audio_repository: Dictionary = get_parent().audio_repository

func _on_finished() -> void:
	if not self in get_parent().available_players_list:
		get_parent().available_players_list.append(self)
		if self in get_parent().busy_players_list:
			get_parent().busy_players_list.erase(self)
		
func _process(_delta: float) -> void:
	if self.playing:
		get_parent().available_players_list.erase(self)
		if self not in get_parent().busy_players_list:
			get_parent().busy_players_list.append(self)

func _play(audio_name: String):
	if self.stream != audio_repository[audio_name]:
		self.stream = audio_repository[audio_name]
	self.play()
	
func _force_availability():
	self.stop()
	get_parent().busy_players_list.erase(self)
	get_parent().available_players_list.append(self)
