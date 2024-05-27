extends Control

@onready var badge_list: ItemList = $CenterContainer/VBoxContainer/ItemList
@onready var _notification: Popup = $Notification
@onready var _notification_text: RichTextLabel = $Notification/CenterContainer/VBoxContainer/RichTextLabel
@onready var confirmation: Popup = $Confirmation

## This array MUST be 1:1 with the item list!
var badge_file_list: PackedStringArray


func _ready() -> void:
	populate_list()


func populate_list() -> void:
	var season_text: String = "Season "
	if DirAccess.dir_exists_absolute(DataHandler.user_season_dir):
		var season_dirs: PackedStringArray = DirAccess.get_directories_at(DataHandler.user_season_dir)
		for dir in season_dirs:
			var tmp: PackedStringArray = dir.split("_")
			var idx: int = badge_list.add_item(season_text + tmp[1] + ":")
			badge_list.set_item_selectable(idx, false)
			badge_list.set_item_custom_fg_color(idx, Color.HONEYDEW)
			badge_list.set_item_custom_bg_color(idx, Color.BLUE_VIOLET)
			for file in DirAccess.get_files_at(DataHandler.user_season_dir + dir):
				tmp = file.split(".")
				idx = badge_list.add_item(tmp[0])
				badge_file_list.append(DataHandler.user_season_dir + dir + "/" + file)


func _on_delete_button_pressed() -> void:
	if badge_list.get_selected_items().is_empty():
		_notification_text.text = "No files selected!"
		_notification.popup()
	else:
		# Delete stuff
		for file_itr in badge_list.get_selected_items().size():
			var itr: PackedInt32Array = badge_list.get_selected_items()
			# Delete stuff
			var badge_dir := DirAccess.open(DataHandler.user_season_dir)
			# Remove the item from the list
			badge_list.remove_item(itr[file_itr-1])
			# Delete the item from the disk
			# TRIPPLE CHECK THIS COMMAND!!!!!!!!!!!
			#badge_dir.remove(badge_file_list[itr[file-1]])
			print("False Delete: ", badge_file_list[itr[file_itr-1]])


func _on_notification_ok_button_pressed() -> void:
	_notification.hide()


## Backarrow button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/settings_menu.tscn"))
