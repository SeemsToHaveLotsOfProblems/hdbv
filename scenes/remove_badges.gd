extends Control

@onready var badge_list: ItemList = $CenterContainer/VBoxContainer/ItemList
@onready var _notification: Popup = $Notification
@onready var _notification_text: RichTextLabel = $Notification/CenterContainer/VBoxContainer/RichTextLabel
@onready var confirmation: Popup = $Confirmation

## This array MUST be 1:1 with the item list!
var badge_file_list: PackedStringArray = []

## This variable is just extra security on the deletion process to ensure that
## only the badge files are deleted.
var allowed_deletion: PackedStringArray = [
	".jpeg",
	".jpg",
	".webp",
	".png"
]


func _ready() -> void:
	populate_list()


func populate_list() -> void:
	# Clear out the file list.
	badge_file_list.clear()
	var season_text: String = "Season "
	if DirAccess.dir_exists_absolute(DataHandler.user_season_dir):
		var season_dirs: PackedStringArray = DirAccess.get_directories_at(DataHandler.user_season_dir)
		# Removing empty directories
		for dir in season_dirs:
			print("Is dir(",dir , ") ", "empty?: ",DirAccess.get_files_at(DataHandler.user_season_dir + dir + "/").is_empty())
			if DirAccess.get_files_at(DataHandler.user_season_dir + dir + "/").is_empty():
				# Delete the directory becuase it's empty
				DirAccess.remove_absolute(DataHandler.user_season_dir + dir + "/")
			else:
				var tmp: PackedStringArray = dir.split("_")
				var idx: int = badge_list.add_item(season_text + tmp[1] + ":")
				badge_list.set_item_selectable(idx, false)
				badge_list.set_item_custom_fg_color(idx, Color.HONEYDEW)
				badge_list.set_item_custom_bg_color(idx, Color.BLUE_VIOLET)
				badge_file_list.append("Season: " + dir)
				for file in DirAccess.get_files_at(DataHandler.user_season_dir + dir):
					tmp = file.split(".")
					idx = badge_list.add_item(tmp[0])
					# BUG: This variable is my issue!!!!
					badge_file_list.append(DataHandler.user_season_dir + dir + "/" + file)


func _on_delete_button_pressed() -> void:
	if badge_list.get_selected_items().is_empty():
		_notification_text.text = "No files selected!"
		_notification.popup()
	else:
		# BUG
		# There is an odd bug where the first file in the list cannot be deleted...?
		# /BUG
		# Delete stuff
		var selected_items: PackedInt32Array = badge_list.get_selected_items()
		for file_itr in badge_list.get_selected_items().size():
			# Delete stuff
			var badge_dir := DirAccess.open(DataHandler.user_season_dir)
			# Ensure the file exists before attempting to delete.
			print("File being checked: ", badge_file_list[selected_items[file_itr]-1])
			print("Does file exists?: ", FileAccess.file_exists(badge_file_list[selected_items[file_itr]-1]))
			if FileAccess.file_exists(badge_file_list[selected_items[file_itr]-1]):
				for safty in allowed_deletion:
					if badge_file_list[selected_items[file_itr] - file_itr].ends_with(safty):
						# Delete the item from the disk
						print("Selected Item Idx: ", selected_items[file_itr])
						print("File Itr: ", file_itr)
						print("Badge List Item Selected: ", badge_list.get_item_text(selected_items[file_itr]))
						print("Badge File List: ", badge_file_list)
						print("File Deleted: ", badge_file_list[selected_items[file_itr]], "\n")
						badge_dir.remove(badge_file_list[selected_items[file_itr]])
		badge_list.clear()
		populate_list()


func _on_notification_ok_button_pressed() -> void:
	_notification.hide()


## Backarrow button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/settings_menu.tscn"))
