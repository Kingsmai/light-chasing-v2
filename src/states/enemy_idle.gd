extends State
class_name EnemyIdle

@onready var enemy: Enemy = $"../.."
@onready var anim: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var idle_time : float = 3.0


func randomize_new_state():
	match randi() % 2:
		0:
			# idle state
			transitioned.emit(self, "EnemyIdle")
		1:
			# patrol state
			transitioned.emit(self, "EnemyPatrol")


func enter() -> void:
	idle_time = randf_range(2, 4)
	enemy.velocity = Vector2.ZERO
	anim.play("idle")
	print(enemy.name + str(enemy.get_rid()) + " is idling for " + str(idle_time) + "s")


func update(delta: float) -> void:
	# 判断敌人是否死亡
	if enemy.health <= 0:
		transitioned.emit(self, "EnemyDeath")
	# 如果敌人在冷却状态内，那就继续 idle
	if enemy.attack_cooldown_timer >= 0.0:
		return
	if idle_time > 0.0:
		idle_time -= delta
	else:
		randomize_new_state()
	if enemy.direction_with_player.length() < enemy.chase_threshold:
		transitioned.emit(self, "EnemyChase")
