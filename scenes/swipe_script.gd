extends CanvasLayer

var swipe_start := Vector2.ZERO
var swipe_end := Vector2.ZERO

@export var ignore_range: int = 100


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start = event.get_position()
		else:
			swipe_end = event.get_position()
			calculate_swipe()


func calculate_swipe() -> void:
	# Ignores the code if the start of the swipe wasn't found.
	if swipe_start == Vector2.ZERO:
		return
		
	var swipe = swipe_end - swipe_start
	if swipe.x > ignore_range:
		SignalBus.emit_signal("next_badge")
	elif swipe.x < -ignore_range:
		SignalBus.emit_signal("prev_badge")
