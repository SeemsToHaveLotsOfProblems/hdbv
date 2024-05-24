extends Node

const user_data_location: String = "user://hdbv/"


func store_settings() -> void:
	var settings_file := FileAccess.open(user_data_location + "settings.ini", FileAccess.WRITE)
	#var data_line: String = "[BADGE_SCALE]\n" + str(GlobalValues.BADGE_SCALE.x)
	# Grab the key names
	var keys: PackedStringArray = GlobalValues.settings.keys()
	# Store the data with the key values
	for i in keys:
		settings_file.store_line("[" + i + "]" + "\n" + str(GlobalValues.settings[i]))


func settings_reader() -> void:
	# Attempt to load in user settings if a settings file is found.
	var settings_file := FileAccess.open(user_data_location + "settings.ini", FileAccess.READ)
	if settings_file:
		parse_ini(settings_file)
	else:
		# Open the user directory
		var dir_builder := DirAccess.open("user://")
		# make the user hdbv directory
		dir_builder.make_dir(user_data_location)
		# Create a settings file
		settings_file = FileAccess.open(user_data_location + "settings.ini", FileAccess.WRITE)
		# Checking to see if the settings file was created successfully
		if settings_file:
			# Storing the settings data
			store_settings()
		else:
			# Printing an error message
			GlobalValues.error_handler("Cannot find or create the settings file", "data_handler.gd", "settings_reader()")


func find_setting(_setting: String, _data: String) -> void:
	_setting = _setting.lstrip("[")
	_setting = _setting.rstrip("]")
	if GlobalValues.settings.has(_setting):
		GlobalValues.settings[_setting] = int(_data)
	else:
		GlobalValues.error_handler("Unable to find setting: \"" + _setting + "\"", "data_handler.gd", "find_settings()")


func parse_ini(settings_file: FileAccess) -> void:
	var file_data: String = settings_file.get_as_text()
	var _setting: String = ""
	var _data: String = ""
	var write_data_line: bool = false
	for itr in file_data:
		if itr != "\n":
			if write_data_line:
				_data += itr
			else:
				_setting += itr
		elif itr == "\n":
			if write_data_line:
				find_setting(_setting, _data)
				_setting = ""
				_data = ""
				write_data_line = false
			else:
				write_data_line = true
