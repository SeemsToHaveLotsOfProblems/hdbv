extends Node

enum current_scene {
	MAIN_MENU = 0,
	VIEWING_BADGES,
}

const asset_location: String = "res://assets/badges/"


var scene: int = current_scene.MAIN_MENU
var current_badge_being_viewed: int = 0
var season_count: int = 4

## Do not write directly to dictonary, use the change_settings() function
var settings: Dictionary = {
	"badge_scale" : 2,
	"season_itr" : 1,
}


func _ready() -> void:
	# Uncomment the following line when it's finished being set up.
	DataHandler.settings_reader()


## Use this function to modify the settings dictionary.
func change_setting(key: String, val: int) -> void:
	# This function is used instead of direct modifications so that
	# proper settings file saving may be done.
	if settings.has(key):
		settings[key] = val
		DataHandler.store_settings()
	else:
		error_handler("Cannot write to settings dictionary!", "global_values.gd", "change_settings()")


func error_handler(error_message: String, script_name: String, function_name: String) -> void:
	print("Error: " + error_message + "!\nScript: " + script_name + "\t|\tFunction: " + function_name)


