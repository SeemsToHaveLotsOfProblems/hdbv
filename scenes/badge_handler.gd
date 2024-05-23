extends Control

# Grabbing a reference to the needed nodes.
@onready var badge_name: RichTextLabel = $VBoxContainer/BadgeName
@onready var badge: TextureRect = $Badge

# The badge season that the user chose.
var season_choice: int = 1

var badge_files: PackedStringArray 
var total_badges_in_season: int = 0

var accepted_extentions: PackedStringArray = [
	".jpeg.import",
	".webp.import",
	".png.import"
]

# The count of where in the array the user is. Do not modify this directly.
var badge_itr: int = 0 : 
	set(value):
		badge_itr = value
		GlobalValues.current_badge_being_viewed = badge_itr


var badge_pos: Array[Vector2] = [Vector2(463,271), Vector2(381,144), Vector2(305,87)]


func _ready() -> void:
	GlobalValues.scene = GlobalValues.current_scene.VIEWING_BADGES
	# Setting the season to the user chosen season.
	season_choice = GlobalValues.season
	# Sets the badge back the the one being viewed last if applicable.
	badge_itr = GlobalValues.current_badge_being_viewed
	# Set the badge season
	season_choice = GlobalValues.season
	# Find badges in the season
	find_badge_count()
	# Display a badge
	change_badge()
	# Connect the signals
	SignalBus.connect("next_badge", next_badge)
	SignalBus.connect("prev_badge", prev_badge)


func _input(event: InputEvent) -> void:
	if event.is_action_released("next"):
		next_badge()
	elif event.is_action_released("prev"):
		prev_badge()


# Finds the number of badges in the season.
func find_badge_count() -> void:
	var dir := DirAccess.open("res://assets/badges/season" + str(season_choice) + "/")
	if dir:
		var tmp: PackedStringArray = dir.get_files()
		for i in tmp:
			for x in accepted_extentions:
				if i.ends_with(x):
					print("Added: ", i, " to the badge list!")
					badge_files.append(i)
		total_badges_in_season = badge_files.size()


func change_badge() -> void:
	var _badge_name: PackedStringArray = badge_files[badge_itr].rsplit(".import")
	var img_txt := ResourceLoader.load("res://assets/badges/season" + str(season_choice) + "/" + _badge_name[0])
	badge.position = badge_pos[GlobalValues.BADGE_SCALE.x - 1]
	badge.scale = GlobalValues.BADGE_SCALE
	badge.texture = img_txt
	var bn: PackedStringArray = _badge_name[0].split(".")
	badge_name.text = "[center][rainbow]" + bn[0]


func next_badge() -> void:
	badge_itr += 1
	if badge_itr >= total_badges_in_season:
		badge_itr = 0
	change_badge()


func prev_badge() -> void:
	badge_itr -= 1
	if badge_itr < 0:
		badge_itr = total_badges_in_season - 1
	change_badge()
