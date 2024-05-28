extends Control

@onready var file_select_Dialog: FileDialog = $CenterContainer/VBoxContainer/BadgeFileSelectorHBox/FileDialog
@onready var spin_box: SpinBox = $CenterContainer/VBoxContainer/SpinBox
@onready var file_path_text_label: = $CenterContainer/VBoxContainer/BadgeFileSelectorHBox/FilePathBackground/FilePathRichTextLable
@onready var badge_list: ItemList = $CenterContainer/VBoxContainer/BadgeList
@onready var notification_popup: Popup = $NotificationPopup
@onready var _notification: RichTextLabel = $NotificationPopup/CenterContainer/VBoxContainer/NotificationLabel
@onready var del_from_lst_btn: Button = $CenterContainer/VBoxContainer/DeleteFromListButton
@onready var del_popup: Popup = $DeleteItemPopup
@onready var save_popup: Popup = $SaveImagesPopup
@onready var save_text: RichTextLabel = $SaveImagesPopup/CenterContainer/VBoxContainer/SaveTextLabel


## Calls the file selection window
func _on_file_select_button_pressed() -> void:
	file_select_Dialog.size = Vector2(500, 600)
	file_select_Dialog.popup()


## Push the badge files into an array
func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	# This will add the file path and img to the item list
	var allowed_extentions: PackedStringArray = [
		".png",
		".jpg",
		".jpeg",
		".webp"
	]
	var img_txt: Texture2D
	for i in paths:
		# Ensures that only image files are loaded
		for x in allowed_extentions:
			if i.ends_with(x): 
				var _img := Image.load_from_file(i)
				var _texture := ImageTexture.create_from_image(_img)
				img_txt = _texture
				badge_list.add_item(i, img_txt)
				del_from_lst_btn.visible = true

func check_dir_path(path: String) -> void:
	var dir := DirAccess.open(DataHandler.user_season_dir)
	# If the directory exist than nothing needs to be done.
	if dir.file_exists(path):
		return
	# Creating the season directory
	dir.make_dir(path)


func _on_back_to_settings_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/settings_menu.tscn"))


# Copying the badge files to the user badge folder.
func _on_save_and_make_badge_button_pressed() -> void:
	if badge_list.get_item_text(0).is_empty():
		_notification.text = "No image files were selected!"
		notification_popup.popup()
		return
	save_text.text = "Save chosen images as [color=green]Season: " + str(spin_box.value) + "[/color], badges?"
	save_popup.popup()


func _on_saved_popup_ok_button_pressed() -> void:
	notification_popup.hide()


func _on_delete_from_list_button_pressed() -> void:
	if badge_list.get_selected_items().is_empty():
		_notification.text = "No files in the list are selected!"
		notification_popup.popup()
	else:
		del_popup.popup()


func _on_remove_from_list_confirm_button_pressed() -> void:
	# Delete the selected items from the list
	# NOTE: If you iterate through the list directly while deleting the indexes will be wrong.
	#       The itr_fix var is my solution to that.
	for i in badge_list.get_selected_items().size():
		var itr_fix:PackedInt32Array = badge_list.get_selected_items()
		badge_list.remove_item(itr_fix[i-1])
	# Hides the remove item button if the list is empty
	# NOTE: This does work, but it also throws a safe-error which I don't like.
	if not badge_list.get_item_text(0):
		del_from_lst_btn.visible = false
	# Close the popup
	del_popup.hide()


func _on_remove_from_list_cancel_button_pressed() -> void:
	del_popup.hide()


func _on_save_list_confirm_button_pressed() -> void:
	var dir := DirAccess.open(DataHandler.user_season_dir)
	var dir_path: String = DataHandler.user_season_dir + "s_" + str(spin_box.value) + "/"
	check_dir_path(dir_path)
	for i in badge_list.get_item_count():
		var itm_name: String = badge_list.get_item_text(i)
		# Spliting the filepath into seperate strings
		var ss: PackedStringArray = itm_name.split("/")
		# Finding the file name from the end of the string array
		var file_name: String = ss[ss.size()-1]
		# Copying the image file.
		dir.copy(itm_name, dir_path + file_name)
	# Hide confirm popup
	save_popup.hide()
	# Show popup that tells the user their files are saved.
	notification_popup.popup()
	badge_list.clear()
	del_from_lst_btn.visible = false
	GlobalValues.checked_user_badges = false
	SignalBus.emit_signal("season_check_requested")
	GlobalValues.season_count += 1


func _on_save_list_cancel_button_pressed() -> void:
	save_popup.hide()


func _on_spin_box_value_changed(_value: float) -> void:
	if spin_box.value > GlobalValues.season_count + 1:
		spin_box.value = GlobalValues.season_count + 1
