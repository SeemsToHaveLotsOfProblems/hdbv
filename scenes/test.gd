extends TextureRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# WORKS!!!!!!!!!
	# Now Things can go back to the original way!
	var img_txt := ResourceLoader.load("res://assets/badges/season2/images/Badge_S2_EP01_-_The_Making_Music_Badge.webp")
	texture = img_txt
