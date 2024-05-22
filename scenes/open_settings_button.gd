extends Button


func _on_pressed() -> void:
	GlobalValues.scene = GlobalValues.current_scene.VIEWING_BADGES
	get_tree().change_scene_to_packed(load("res://scenes/settings_menu.tscn"))
