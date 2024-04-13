extends Area2D
class_name Torch

var enemies_in_lights : Array[Enemy]
@onready var player_energy: PlayerEnergy = $"../../PlayerEnergy"


func _process(delta: float) -> void:
	for enemy in enemies_in_lights:
		enemy.take_damage(delta * player_energy.damage)
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Enemy and body not in enemies_in_lights:
		enemies_in_lights.append(body)


func _on_body_exited(body: Node2D) -> void:
	if body is Enemy and body in enemies_in_lights:
		enemies_in_lights.erase(body)
