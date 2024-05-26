extends Control

@onready var badge_list: ItemList = $CenterContainer/VBoxContainer/ItemList
@onready var _notification: Popup = $Notification
@onready var _notification_text: RichTextLabel = $Notification/CenterContainer/VBoxContainer/RichTextLabel
@onready var confirmation: Popup = $Confirmation


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


func _on_delete_button_pressed() -> void:
	if badge_list.get_selected_items().is_empty():
		_notification_text.text = "No files selected!"
		_notification.popup()


func _on_notification_ok_button_pressed() -> void:
	_notification.hide()
