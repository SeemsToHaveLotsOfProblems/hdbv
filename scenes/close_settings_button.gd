extends Button


func _on_pressed() -> void:
	var scene_to_load: String = ""
	match GlobalValues.scene:
		GlobalValues.current_scene.MAIN_MENU:
			scene_to_load = "res://scenes/main_menu.tscn"
		GlobalValues.current_scene.VIEWING_BADGES:
			scene_to_load = "res://scenes/badge_viewer.tscn"
	
	get_tree().change_scene_to_packed(load(scene_to_load))
