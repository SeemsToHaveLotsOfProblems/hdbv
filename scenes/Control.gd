extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.connect("badge_control_node_requested", send_self)


func send_self() -> void:
	SignalBus.emit_signal("badge_control_loaded", self)
