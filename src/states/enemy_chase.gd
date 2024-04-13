extends State
class_name EnemyChase

@onready var enemy: Enemy = $"../.."
@onready var anim: AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter():
	print(enemy.name + str(enemy.get_rid()) + " is chasing player")
	anim.play("run")


func update(delta):
	# 判断敌人是否死亡
	if enemy.health <= 0.0:
		transitioned.emit(self, "EnemyDeath")
	# 如果敌人在冷却状态内，那就直接 idle
	if enemy.attack_cooldown_timer >= 0.0:
		transitioned.emit(self, "EnemyIdle")


func physic_update(delta):
	if enemy.direction_with_player.length() > 10:
		enemy.velocity = enemy.direction_with_player.normalized() * enemy.chase_speed
	else:
		enemy.velocity = Vector2.ZERO
		# Collide with player, performing attack
		if enemy.attack_cooldown_timer <= 0:
			print(enemy.name + str(enemy.get_rid()) + " is attacking player")
			enemy.player.player_health.take_damage(enemy.damage)
			enemy.attack_cooldown_timer = enemy.attack_cooldown
	
	if enemy.direction_with_player.length() > enemy.chase_threshold:
		transitioned.emit(self, "EnemyIdle")
	
	anim.flip_h = enemy.velocity.x < 0
