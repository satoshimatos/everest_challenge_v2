@tool
extends EditorScript

func _run():
	var audio_dir = "res://assets/audio"
	var audio_dict = {}
	var files = get_all_wav_files(audio_dir)

	for file_path in files:
		var file_name = file_path.get_file().get_basename()
		audio_dict[file_name] = file_path

	print("== Preload Dictionary ==")
	for key in audio_dict.keys():
		print("\"%s\"," % [audio_dict[key]])

	print("== DONE ==")

func get_all_wav_files(path: String) -> Array:
	var result = []
	var dir = DirAccess.open(path)

	if not dir:
		print("Can't open directory: ", path)
		return result

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				result += get_all_wav_files(path + "/" + file_name)
		elif file_name.ends_with(".wav"):
			result.append(path + "/" + file_name)

		file_name = dir.get_next()

	dir.list_dir_end()
	return result
