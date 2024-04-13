extends Node
class_name State

signal transitioned(state : State, new_state_name : String)


func enter() -> void:
	pass


func exit() -> void:
	pass


func update(delta: float) -> void:
	pass


func physic_update(delta: float) -> void:
	pass
