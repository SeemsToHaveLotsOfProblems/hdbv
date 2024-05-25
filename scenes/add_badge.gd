extends Control

@onready var file_select_Dialog: FileDialog = $CenterContainer/VBoxContainer/BadgeFileSelectorHBox/FileDialog
@onready var spin_box: SpinBox = $CenterContainer/VBoxContainer/SpinBox

## Calls the file selection window
func _on_file_select_button_pressed() -> void:
	file_select_Dialog.size = Vector2(500, 600)
	file_select_Dialog.popup()


func _on_file_dialog_files_selected(paths: PackedStringArray) -> void:
	print(paths)
	var dir := DirAccess.open(DataHandler.user_season_dir)
	var dir_path: String = DataHandler.user_season_dir + "s_" + str(spin_box.value) + "/"
	check_dir_path(dir_path)
	for i in paths:
		# Spliting the filepath into seperate strings
		var ss: PackedStringArray = i.split("/")
		# Finding the file name from the end of the string array
		var file_name: String = ss[ss.size()-1]
		# Copying the image file.
		dir.copy(i, dir_path + file_name)


func check_dir_path(path: String) -> void:
	var dir := DirAccess.open(DataHandler.user_season_dir)
	# If the directory exist than nothing needs to be done.
	if dir.file_exists(path):
		return
	# Creating the season directory
	dir.make_dir(path)
