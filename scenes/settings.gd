extends VBoxContainer

# Node refereces
@onready var badge_scale_text: RichTextLabel = $BadgeScaleLable
@onready var badge_scale_slider: HSlider = $BadgeScaleSlider


func _ready() -> void:
	badge_scale_slider.value = GlobalValues.settings["badge_scale"]
	badge_scale_text.text = "Badge Size: " + str(GlobalValues.settings["badge_scale"])


func _on_badge_scale_slider_value_changed(value: float) -> void:
	badge_scale_text.text = "Badge Size: " + str(value)
	# Safe to ignore as this can only be 1.0, 2.0, or 3.0
	@warning_ignore("narrowing_conversion")
	GlobalValues.change_setting("badge_scale", value)


# Add badge button
func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/add_badge.tscn"))


func _on_delete_badges_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/remove_badges.tscn"))
