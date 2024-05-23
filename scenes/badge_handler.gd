extends Control

# Grabbing a reference to the needed nodes.
@onready var badge_name: RichTextLabel = $VBoxContainer/BadgeName

# The badge season that the user chose.
var season_choice: int = 1

var total_badges_in_season: int = 0

var cur_badge_ref: TextureRect = null

# The count of where in the array the user is. Do not modify this directly.
var badge_itr: int = 0 : 
	set(value):
		badge_itr = value
		GlobalValues.current_badge_being_viewed = badge_itr

@onready var s1_badges: Node2D = $s1_badges
@onready var s2_badges: Node2D = $s2_badges
@onready var s3_badges: Node2D = $s3_badges
@onready var s4_badges: Node2D = $s4_badges

var badge_pos: Array[Vector2] = [Vector2(463,271), Vector2(381,144), Vector2(305,87)]


func _ready() -> void:
	GlobalValues.scene = GlobalValues.current_scene.VIEWING_BADGES
	# Setting the season to the user chosen season.
	season_choice = GlobalValues.season
	# Sets the badge back the the one being viewed last if applicable.
	badge_itr = GlobalValues.current_badge_being_viewed
	# Create the badge and add it to the scene.
	set_badge_season()
	find_badge_count()
	change_badge()
	# Connect the signals
	SignalBus.connect("next_badge", next_badge)
	SignalBus.connect("prev_badge", prev_badge)


func _input(event: InputEvent) -> void:
	if event.is_action_released("next"):
		next_badge()
	elif event.is_action_released("prev"):
		prev_badge()


func set_badge_season() -> void:
	match season_choice:
		1:
			s1_badges.visible = true
		2:
			s2_badges.visible = true
		3:
			s3_badges.visible = true
		4:
			s4_badges.visible = true
		_:
			GlobalValues.error_handler("Unable to find the chosen season", "badge_handler.gd", 44, 49)


# Finds the number of badges in the season.
func find_badge_count() -> void:
	match season_choice:
		1:
			total_badges_in_season = s1_badges.get_child_count()
		2:
			total_badges_in_season = s2_badges.get_child_count()
		3:
			total_badges_in_season = s3_badges.get_child_count()
		4:
			total_badges_in_season = s4_badges.get_child_count()
		_:
			GlobalValues.error_handler("Unable to find the chosen season", "badge_handler.gd", 53, 58)


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


func change_badge() -> void:
	var _season: Node2D = null
	# Find which season to show.
	match season_choice:
		1:
			_season = s1_badges
		2:
			_season = s2_badges
		3:
			_season = s3_badges
		4:
			_season = s4_badges
		_:
			GlobalValues.error_handler("Unable to find the chosen season", "badge_handler.gd", 77, 00)
			return
	
	# Hide old badge if there's a reference to it
	if cur_badge_ref != null:
		cur_badge_ref.visible = false
		
	
	# Setting the new badge reference
	cur_badge_ref = _season.get_child(badge_itr)
	# Explicitly setting the scale and position
	cur_badge_ref.scale = GlobalValues.BADGE_SCALE
	_season.position = badge_pos[GlobalValues.BADGE_SCALE.x-1]
	# Updating the badge name
	badge_name.text = "[center][rainbow]" + cur_badge_ref.badge_name
	# Making the badge visible
	cur_badge_ref.visible = true

