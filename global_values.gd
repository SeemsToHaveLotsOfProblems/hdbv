extends Node

enum current_scene {
	MAIN_MENU = 0,
	VIEWING_BADGES,
}

const asset_location: String = "res://assets/badges/"
const user_data_location: String = "user://hdbv/"


var scene: int = current_scene.MAIN_MENU
var season: int = 1
var current_badge_being_viewed: int = 0
var BADGE_SCALE := Vector2(2,2)


func _ready() -> void:
	# Uncomment the following line when it's finished being set up.
	# settings_reader()
	pass


func error_handler(error_message: String, script_name: String, line_start:int, line_end: int) -> void:
	print("Error: " + error_message + "!\nScript: " + script_name + "\t|\tLine: " + str(line_start) + "-" + str(line_end))


func settings_reader() -> void:
	# Attempt to load in user settings if a settings file is found.
	var settings_file := FileAccess.open(user_data_location + "settings.ini", FileAccess.READ)
	if settings_file:
		parse_ini(settings_file)
	else:
		# Create a settings file if one doesn't exists.
		settings_file = FileAccess.open(user_data_location + "settings.ini", FileAccess.WRITE)
		var data_line: String = "[BADGE_SCALE]\n" + str(BADGE_SCALE)
		settings_file.store_line(data_line)


func parse_ini(settings_file: FileAccess) -> void:
	var file_data: String = settings_file.get_as_text()
	# Parse data and pass in the saved data.
