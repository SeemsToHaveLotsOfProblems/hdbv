extends Node

enum current_scene {
	MAIN_MENU = 0,
	VIEWING_BADGES,
}

const asset_location: String = "res://assets/badges/"


var scene: int = current_scene.MAIN_MENU
var current_badge_being_viewed: int = 0

## Do not write directly to dictonary, use the change_settings() function
var settings: Dictionary = {
	"badge_scale" : 2,
	"season_itr" : 1,
}


func _ready() -> void:
	# Uncomment the following line when it's finished being set up.
	DataHandler.settings_reader()


func change_setting(key: String, val: int) -> void:
	if settings.has(key):
		settings[key] = val
		DataHandler.store_settings()
	else:
		error_handler("Cannot write to settings dictionary!", "global_values.gd", "change_settings()")


func error_handler(error_message: String, script_name: String, function_name: String) -> void:
	print("Error: " + error_message + "!\nScript: " + script_name + "\t|\tFunction: " + function_name)


