extends CharacterBody2D
class_name Enemy

@onready var color_indicator: Sprite2D = $ColorIndicator
@onready var health_bar: ProgressBar = $HealthBar

@export_group("Color")
@export_flags("red", "green", "blue") var weakness_color = 0
@export_group("Behaviour")
@export var patrol_speed : float = 10
@export var chase_speed : float = 40
@export var chase_threshold : float = 80

@export var attack_cooldown : float = 2.0
var attack_cooldown_timer : float = 0

@export var health : float = 2.0 :
	set(val):
		health = val;
		health_bar.value = val / 2.0 * 100
@export var damage : int = 1

var player : Player
var player_energy : PlayerEnergy
var direction_with_player : Vector2


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player_energy = get_tree().get_first_node_in_group("PlayerEnergy")
	y_sort_enabled = true
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	match weakness_color:
		0:
			color_indicator.self_modulate = Color(0, 0, 0)
		1:
			color_indicator.self_modulate = Color(1, 0, 0)
		2:
			color_indicator.self_modulate = Color(0, 1, 0)
		3:
			color_indicator.self_modulate = Color(1, 1, 0)
		4:
			color_indicator.self_modulate = Color(0, 0, 1)
		5:
			color_indicator.self_modulate = Color(1, 0, 1)
		6:
			color_indicator.self_modulate = Color(0, 1, 1)
		7:
			color_indicator.self_modulate = Color(1, 1, 1)

func _process(delta: float) -> void:
	direction_with_player = player.global_position - global_position
	if attack_cooldown_timer >= 0:
		attack_cooldown_timer -= delta


func _physics_process(delta: float) -> void:
	move_and_slide()


func take_damage(amount: float):
	match weakness_color:
		0: # 000 Any color
			pass
		1: # 100 Red
			if player_energy.red_light_on:
				health -= amount
			pass
		2: # 010 Green
			if player_energy.green_light_on:
				health -= amount
			pass
		3: # 110 Yellow
			if player_energy.red_light_on\
			and player_energy.green_light_on:
				health -= amount
			pass
		4: # 001 Blue
			if player_energy.blue_light_on:
				health -= amount
			pass
		5: # 101 Purple
			if player_energy.red_light_on\
			and player_energy.blue_light_on:
				health -= amount
			pass
		6: # 011 Cyan
			if player_energy.green_light_on\
			and player_energy.blue_light_on:
				health -= amount
			pass
		7: # 111 White
			if player_energy.red_light_on\
			and player_energy.green_light_on\
			and player_energy.blue_light_on:
				health -= amount
			pass
