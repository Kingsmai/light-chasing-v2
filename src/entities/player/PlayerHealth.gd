extends Node
class_name PlayerHealth

signal hurt
signal heal
signal death
signal max_health_changed
signal invulnerable_start # 开始无敌
signal invulnerable_end   # 结束无敌

@export var initial_health : float = 3.0

var current_health : float:
	set(val):
		if val >= current_health:
			heal.emit()
		else:
			hurt.emit()
		current_health = max(val, max_health)
		if current_health <= 0:
			print("Player is death")
			death.emit()

var max_health : float :
	set(val):
		max_health = val
		max_health_changed.emit()
		if current_health > max_health:
			current_health = max_health

@export var invulnerable_countdown : float = 3.0
var invulnerable_timer : float = 0.0


func _ready() -> void:
	max_health = initial_health
	current_health = max_health


func _process(delta: float) -> void:
	if invulnerable_timer > 0:
		invulnerable_timer -= delta
		if invulnerable_timer <= 0:
			invulnerable_end.emit()


func take_damage(amount: float) -> void:
	if invulnerable_timer > 0:
		return
	print("Player lose " + str(amount) + " health")
	current_health -= amount
	invulnerable_timer = invulnerable_countdown
	invulnerable_start.emit()


func healing(amount: float) -> void:
	current_health += amount
