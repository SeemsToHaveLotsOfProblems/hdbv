extends Button


func _on_pressed() -> void:
	GlobalValues.current_badge_being_viewed = 0
	get_tree().change_scene_to_packed(load("res://scenes/main_menu.tscn"))
