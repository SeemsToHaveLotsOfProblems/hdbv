extends HBoxContainer

@onready var left_arrow: TextureRect = $Left_Season_Arrow
@onready var right_arrow: TextureRect = $Right_Season_Arrow
@onready var season_name: RichTextLabel = $SeasonName

var season_itr: int = 1 : 
	set(value):
		if value > GlobalValues.season_count:
			season_itr = 1
		elif value < 1:
			season_itr = GlobalValues.season_count
		else:
			season_itr = value

var colors: PackedStringArray = [
	"[color=green]",
	"[color=blue]",
	"[color=red]",
	"[color=brown]",
	"[color=purple]",
	"[color=orange]",
]

func _ready() -> void:
	GlobalValues.scene = GlobalValues.current_scene.MAIN_MENU
	season_itr = GlobalValues.settings["season_itr"]
	season_name.text = colors[season_itr -1] + "SEASON " + str(season_itr)
	check_user_added_seasons()


func _on_right_season_arrow_gui_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		season_itr += 1
		change_season()


func _on_left_season_arrow_gui_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		season_itr -= 1
		change_season()


func change_season() -> void:
	season_name.text = colors[season_itr -1] + "SEASON " + str(season_itr)
	GlobalValues.change_setting("season_itr", season_itr)


func _on_view_badges_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/badge_viewer.tscn"))


## Checks the user data folder for bages that the user may add.
func check_user_added_seasons() -> void:
	if not GlobalValues.checked_user_badges:
		GlobalValues.checked_user_badges = true
		# Opens the user data folder.
		var account_for_season_4: bool = false
		var dir := DirAccess.open(DataHandler.user_season_dir)
		if dir:
			# Get a list of all the season directories in the folder.
			var dir_list: PackedStringArray = dir.get_directories()
			# This is the number of season folders that the user has.
			if dir_list.has("s_4"):
				account_for_season_4 = true
			var dir_size: int = dir_list.size()
			if account_for_season_4:
				GlobalValues.season_count += dir_size - 1
			else:
				GlobalValues.season_count += dir_size
