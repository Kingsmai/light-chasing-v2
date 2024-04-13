extends Node
# 根据 Aiming Joystick 定位出按钮的位置

@onready var movement_joystick: Node2D = $"../MovementJoystick"
@onready var aiming_joystick: Node2D = $"../AimingJoystick"
@onready var skill_buttons : Array[TouchScreenButton] = [
	$"../RedLightButton",
	$"../GreenLightButton",
	$"../BlueLightButton"
]


func _ready() -> void:
	if Global.is_mobile:
		arrange_buttons_around_joystick()
	else:
		set_mobile_controls_visibility()


func arrange_buttons_around_joystick():
	var joystick_radius = 75  # 调整摇杆半径
	var angle_increment = 180.0 / (len(skill_buttons) + 1)
	var current_angle = 180.0  # 起始角度

	for button in skill_buttons:
		if button is TouchScreenButton:  # 确保只选择按钮节点
			var x = joystick_radius * cos(deg_to_rad(current_angle)) + aiming_joystick.position.x
			var y = joystick_radius * sin(deg_to_rad(current_angle)) + aiming_joystick.position.y
			button.scale = Vector2(0.2, 0.2)  # 调整按钮大小
			var button_position = Vector2(x, y)
			print("Place skill button at " + str(button_position))
			button.global_position = button_position
			current_angle += angle_increment


func set_mobile_controls_visibility():
	movement_joystick.visible = false
	aiming_joystick.visible = false
	for skill_button in skill_buttons:
		skill_button.visible = false
