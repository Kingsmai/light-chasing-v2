extends Node
class_name PlayerEnergy

signal red_light_casted
signal green_light_casted
signal blue_light_casted

signal red_light_switch(val: bool)
signal green_light_switch(val: bool)
signal blue_light_switch(val: bool)

signal red_energy_value_changed
signal green_energy_value_changed
signal blue_energy_value_changed

@onready var torch_light: Torch = $"../Hand/TorchLight"

@onready var red_light_anim: AnimationPlayer = $"../Hand/TorchLight/RedLight/RedLightAnim"
@onready var green_light_anim: AnimationPlayer = $"../Hand/TorchLight/GreenLight/GreenLightAnim"
@onready var blue_light_anim: AnimationPlayer = $"../Hand/TorchLight/BlueLight/BlueLightAnim"

@onready var light_polygon: CollisionPolygon2D = $"../Hand/TorchLight/LightPolygon"

var red_light_on: bool = false :
	set(val):
		red_light_on = val
		red_light_switch.emit(val)
var green_light_on: bool = false :
	set(val):
		green_light_on = val
		green_light_switch.emit(val)
var blue_light_on: bool = false :
	set(val):
		blue_light_on = val
		blue_light_switch.emit(val)

@export var max_energy_quota : int = 5
@export var damage : float = 1

@export_group("Initial Energy")
@export var red_initial_energy : int = 2
var red_energy : int:
	set(val):
		if val < max_energy_quota:
			red_energy = val
		red_energy_value_changed.emit()


@export var green_initial_energy : int = 2
var green_energy : int:
	set(val):
		if val < max_energy_quota:
			green_energy = val
		green_energy_value_changed.emit()

@export var blue_initial_energy : int = 2
var blue_energy : int:
	set(val):
		if val < max_energy_quota:
			blue_energy = val
		blue_energy_value_changed.emit()

@export_group("Countdown")
@export var red_countdown : float = 5
var red_countdown_timer : float = 0
@export var green_countdown : float = 5
var green_countdown_timer : float = 0
@export var blue_countdown : float = 5
var blue_countdown_timer : float = 0


func _ready() -> void:
	red_energy = red_initial_energy
	green_energy = green_initial_energy
	blue_energy = blue_initial_energy


func _process(delta: float) -> void:
	if red_countdown_timer > 0:
		red_countdown_timer -= delta
		if red_countdown_timer <= 0:
			print("Red light timeout, switching off...")
			red_light_on = false
			# 如果其他两个灯是关的，就禁用碰撞体
			if not green_light_on and not blue_light_on:
				light_polygon.disabled = true
			red_light_anim.play("off")
	if green_countdown_timer > 0:
		green_countdown_timer -= delta
		if green_countdown_timer <= 0:
			print("Green light timeout, switching off...")
			green_light_on = false
			# 如果其他两个灯是关的，就禁用碰撞体
			if not red_light_on and not blue_light_on:
				light_polygon.disabled = true
			green_light_anim.play("off")
	if blue_countdown_timer > 0:
		blue_countdown_timer -= delta
		if blue_countdown_timer <= 0:
			print("Blue light timeout, switching off...")
			blue_light_on = false
			# 如果其他两个灯是关的，就禁用碰撞体
			if not red_light_on and not green_light_on:
				light_polygon.disabled = true
			blue_light_anim.play("off")


func cast_red_light():
	if red_energy > 0:
		red_energy -= 1
		print("Player casted red light")
		if red_countdown_timer > 0:
			print("Red light cast timer extended")
			red_countdown_timer = red_countdown
		else:
			red_light_anim.play("cast")
			await red_light_anim.animation_finished
			red_light_on = true
			light_polygon.disabled = false
			red_countdown_timer = red_countdown
		red_light_casted.emit()
	else:
		print("Not enough red energy")


func cast_green_light():
	if green_energy > 0:
		green_energy -= 1
		print("Player casted green light")
		if green_countdown_timer > 0:
			print("Green light cast timer extended")
			green_countdown_timer = green_countdown
		else:
			green_light_anim.play("cast")
			await green_light_anim.animation_finished
			green_light_on = true
			light_polygon.disabled = false
			green_countdown_timer = green_countdown
		green_light_casted.emit()
	else:
		print("Not enough green energy")


func cast_blue_light():
	if blue_energy > 0:
		blue_energy -= 1
		print("Player casted blue light")
		if blue_countdown_timer > 0:
			print("Blue light cast timer extended")
			blue_countdown_timer = blue_countdown
		else:
			blue_light_anim.play("cast")
			await blue_light_anim.animation_finished
			blue_light_on = true
			light_polygon.disabled = false
			blue_countdown_timer = blue_countdown
		blue_light_casted.emit()
	else:
		print("Not enough blue energy to cast")


func energy_regen(energy_type : Energy.energy_types):
	print("Regenerate 1 " + Energy.energy_types.keys()[energy_type] + " energy")
	match energy_type:
		Energy.energy_types.RED:
			red_energy += 1
		Energy.energy_types.GREEN:
			green_energy += 1
		Energy.energy_types.BLUE:
			blue_energy += 1
