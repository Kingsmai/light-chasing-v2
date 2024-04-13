extends State
class_name EnemyPatrol

@onready var enemy: Enemy = $"../.."
@onready var anim: AnimatedSprite2D = $"../../AnimatedSprite2D"
@export var move_speed : float = 10.0

var move_direction : Vector2
var wander_time : float


func randomize_new_state():
	match randi() % 2:
		0:
			# idle state
			transitioned.emit(self, "EnemyIdle")
		1:
			# patrol state
			transitioned.emit(self, "EnemyPatrol")


func randomize_wander():
	move_direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	wander_time = randf_range(1, 3)
	print(enemy.name + str(enemy.get_rid()) + " is patrolling for " + str(wander_time) + "s")


func enter():
	anim.play("walk")
	randomize_wander()


func update(delta):
	# 判断敌人是否死亡
	if enemy.health <= 0.0:
		transitioned.emit(self, "EnemyDeath")
	# 如果敌人在冷却状态内，那就直接 idle
	if enemy.attack_cooldown_timer >= 0.0:
		transitioned.emit(self, "EnemyIdle")
	if wander_time > 0.0:
		wander_time -= delta
	else:
		randomize_new_state()
	if enemy.direction_with_player.length() < enemy.chase_threshold:
		transitioned.emit(self, "EnemyChase")


func physic_update(delta):
	if enemy:
		enemy.velocity = move_direction * enemy.patrol_speed
	anim.flip_h = enemy.velocity.x < 0
