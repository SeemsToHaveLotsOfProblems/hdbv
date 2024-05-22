extends Node

enum current_scene {
	MAIN_MENU = 0,
	VIEWING_BADGES,
}

const asset_location: String = "res://assets/badges/"

var scene: int = current_scene.MAIN_MENU
var season: int = 1
var current_badge_being_viewed: int = 0
var BADGE_SCALE := Vector2(2,2)


func error_handler(error_message: String, script_name: String, line_start:int, line_end: int) -> void:
	print("Error: " + error_message + "!\nScript: " + script_name + "\t|\tLine: " + str(line_start) + "-" + str(line_end))
