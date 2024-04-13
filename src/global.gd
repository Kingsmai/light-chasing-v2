extends Node2D

var is_mobile = false


func _ready() -> void:
	var os_name = OS.get_name()
	if os_name == "Android" or os_name == "iOS":
		print("Game is running on mobile device")
		is_mobile = true
	else:
		print("Game is running on computer")
