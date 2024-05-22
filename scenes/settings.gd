extends VBoxContainer

# Node refereces
@onready var badge_scale_text: RichTextLabel = $BadgeScaleLable
@onready var badge_scale_slider: HSlider = $BadgeScaleSlider


func _ready() -> void:
	badge_scale_slider.value = GlobalValues.BADGE_SCALE.x
	badge_scale_text.text = "Badge Size: " + str(GlobalValues.BADGE_SCALE.x)


func _on_badge_scale_slider_value_changed(value: float) -> void:
	badge_scale_text.text = "Badge Size: " + str(value)
	GlobalValues.BADGE_SCALE = Vector2(value, value)
