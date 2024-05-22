extends HBoxContainer

@onready var left_arrow: TextureRect = $Left_Season_Arrow
@onready var right_arrow: TextureRect = $Right_Season_Arrow
@onready var season_name: RichTextLabel = $SeasonName

var season_count: int = 1 : 
	set(value):
		var num: int = GlobalValues.seasons_avalible
		if value > num:
			season_count = 1
		elif value < 1:
			season_count = num
		else:
			season_count = value

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
	GlobalValues.season = season_count
	season_name.text = colors[season_count -1] + "SEASON " + str(season_count)


func _on_right_season_arrow_gui_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		season_count += 1
		change_season()


func _on_left_season_arrow_gui_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		season_count -= 1
		change_season()


func change_season() -> void:
	season_name.text = colors[season_count -1] + "SEASON " + str(season_count)
	GlobalValues.season = season_count


func _on_view_badges_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/badge_viewer.tscn"))
