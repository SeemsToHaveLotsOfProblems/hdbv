extends RichTextLabel

# Place my credits here, and the system will add them into the credit screen.
var credits: PackedStringArray = [
	"Programming & Game Design by:\n\tFatal Error Drive B"
]

# Displays the credits needed by the godot engine
func _ready() -> void:
	build_credits()


func build_credits() -> void:
	text = ""
	for i in credits:
		text += i + "\n"
	text += "\n"
	text += Engine.get_license_text() + "\n\n"
	for i in Engine.get_license_info():
		text += i + "\n\n"
	for i in Engine.get_copyright_info():
		text += i["name"] + "\n\n"
		for x in i["parts"]:
			for y in x["files"]:
				text += y + "\n\t" 
				for z in x["copyright"]:
					text += z + "\n\n" 
				text += x["license"] + "\n"
