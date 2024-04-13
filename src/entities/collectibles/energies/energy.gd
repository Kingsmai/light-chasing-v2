extends Area2D
class_name Energy

@onready var light: PointLight2D = $Light
@onready var anim: AnimationPlayer = $AnimationPlayer

enum energy_types {
	LIGHT,
	RED,
	GREEN,
	BLUE
}

@export var energy_type := energy_types.LIGHT
@export var fading_time = 0.1

var picked : bool = false


func _process(delta: float) -> void:
	if not picked:
		return
	light.texture_scale -= delta * fading_time
	if light.texture_scale <= 0.005:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if not picked and body is Player:
		var player = body as Player
		picked = true
		anim.pause()
		player.body_light.grow_light(light.texture_scale)
		if energy_type != energy_types.LIGHT:
			print("Player is picking up the " + str(energy_type) + " energy.")
			player.player_energy.energy_regen(energy_type)
