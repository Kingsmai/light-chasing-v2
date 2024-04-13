extends CharacterBody2D
class_name Player

@onready var camera: Camera2D = $Camera2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@onready var body_light: BodyLight = $BodyLight
@onready var player_energy: PlayerEnergy = $PlayerEnergy as PlayerEnergy
@onready var hand: Node2D = $Hand

@onready var player_health: PlayerHealth = $PlayerHealth
@onready var player_hitbox: CollisionShape2D = $PlayerHitbox

# Do some action
@export var movement_speed : int = 70
@export var running_speed : int = 120
var move_direction : Vector2
var aim_direction : Vector2
var joystick_move_direction : Vector2
var joystick_aim_direction : Vector2
var using_joystick = false
var is_running : bool = false

var is_hurt : bool = false


func _ready() -> void:
	# Get device name to determine to use virtual joystick or not:
	using_joystick = Global.is_mobile


func _process(delta: float) -> void:
	# Get player input
	if using_joystick:
		move_direction = joystick_move_direction
		aim_direction = joystick_aim_direction
		# TODO: running button held
	else:
		move_direction = Vector2(
			Input.get_axis("left", "right"),
			Input.get_axis("up", "down")
		).normalized()
		aim_direction = (camera.get_global_mouse_position() - global_position).normalized()
		is_running = Input.is_action_pressed("run")
	animate()
	rotate_hand()


func _physics_process(delta: float) -> void:
	movement()


# region: 用户输入
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("skill1"):
		player_energy.cast_red_light()
	elif event.is_action_pressed("skill2"):
		player_energy.cast_green_light()
	elif event.is_action_pressed("skill3"):
		player_energy.cast_blue_light()


func _on_movement_joystick_analogic_chage(move:Vector2) -> void:
	joystick_move_direction = move


func _on_aiming_joystick_analogic_chage(move:Vector2) -> void:
	joystick_aim_direction = move


func _on_red_light_button_pressed() -> void:
	player_energy.cast_red_light()


func _on_green_light_button_pressed() -> void:
	player_energy.cast_green_light()


func _on_blue_light_button_pressed() -> void:
	player_energy.cast_blue_light()
# endregion


func movement():
	if not is_running:
		velocity = move_direction * movement_speed
	else:
		velocity = move_direction * running_speed
	move_and_slide()


func rotate_hand():
	if aim_direction != Vector2.ZERO:
		hand.rotation = aim_direction.angle()


func animate():
	if is_hurt:
		anim.play("hurt")
		await anim.animation_finished
		is_hurt = false
	# Flip player sprite
	anim.flip_h = aim_direction.x < 0
	if velocity != Vector2.ZERO:
		if not is_running:
			anim.play("walk")
		else:
			anim.play("run")
	else:
		anim.play("idle")


func setup_camera_limit(start:Vector2, end:Vector2) -> void:
	var camera: Camera2D = $Camera2D
	camera.limit_left = start.x
	camera.limit_top = start.y
	camera.limit_right = end.x
	camera.limit_bottom = end.y

# region: health changed
func _on_player_health_hurt() -> void:
	is_hurt = true
# endregion


func _on_player_health_invulnerable_start() -> void:
	pass


func _on_player_health_invulnerable_end() -> void:
	pass
