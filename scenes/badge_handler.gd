extends Control

# Grabbing a reference to the needed nodes.
@onready var badge_name: RichTextLabel = $VBoxContainer/BadgeName
@onready var badge: TextureRect = $Badge

# The badge season that the user chose.
var season_choice: int = 1

var badge_files: PackedStringArray 
var user_badge_files: PackedStringArray
var total_badges_in_season: int = 0

var accepted_extentions: PackedStringArray = [
	".jpeg.import",
	".jpg.import",
	".webp.import",
	".png.import",
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
	season_choice = GlobalValues.settings["season_itr"]
	# Sets the badge back the the one being viewed last if applicable.
	badge_itr = GlobalValues.current_badge_being_viewed
	# Set the badge season
	season_choice = GlobalValues.settings["season_itr"]
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
	var dir := DirAccess.open(GlobalValues.asset_location + "season" + str(season_choice) + "/")
	if dir:
		var tmp: PackedStringArray = dir.get_files()
		for i in tmp:
			for x in accepted_extentions:
				if i.capitalize().ends_with(x):
					badge_files.append(i)
		total_badges_in_season = badge_files.size()
	
	check_user_added_badges()


func change_badge() -> void:
	var _badge_name: PackedStringArray = badge_files[badge_itr].rsplit(".import")
	var img_txt: Texture2D
	if badge_files[badge_itr] in user_badge_files:
		# Loading in the user added images for badges.
		var _img := Image.load_from_file(DataHandler.user_season_dir + "s_" + str(season_choice) + "/" + _badge_name[0])
		var _img_texture := ImageTexture.create_from_image(_img)
		img_txt = _img_texture
	else:
		# Loading in default asset images
		img_txt = ResourceLoader.load(GlobalValues.asset_location + "season" + str(season_choice) + "/" + _badge_name[0])
	# Setting badge size to ensure proper sizing
	badge.size = Vector2(180, 180)
	# Setting badge position
	badge.position = badge_pos[GlobalValues.settings["badge_scale"] - 1]
	# Setting badge scale
	badge.scale = Vector2(GlobalValues.settings["badge_scale"], GlobalValues.settings["badge_scale"])
	badge.texture = img_txt
	var bn: PackedStringArray = _badge_name[0].split(".")
	badge_name.text = "[center][rainbow]" + bn[0]


## Checks the user data folder for bages that the user may add.
func check_user_added_badges() -> void:
	# If the user badge folder doesn't exist it will create it.
	if not DirAccess.dir_exists_absolute(DataHandler.user_season_dir):
		DirAccess.make_dir_recursive_absolute(DataHandler.user_season_dir)
	# Opening the user badge folder
	var dir := DirAccess.open(DataHandler.user_season_dir)
	for i in dir.get_directories():
		# Checks the folder name to see if it matches the season number
		if i == "s_" + str(GlobalValues.settings["season_itr"]):
			# Find badges in folder and add them to the badge array.
			var files := DirAccess.open(DataHandler.user_season_dir + "s_" + str(GlobalValues.settings["season_itr"]))
			for y in files.get_files():
				badge_files.append(y + ".import")
				# Adding to a second array so I can properly track them for loading.
				user_badge_files.append(y + ".import")
				# Update the total badges in season variable so that the index
				# will reach the new badges.
				total_badges_in_season = badge_files.size()


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
