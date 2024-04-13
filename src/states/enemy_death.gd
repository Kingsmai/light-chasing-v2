extends State
class_name EnemyDeath

@onready var enemy: Enemy = $"../.."
@onready var anim: AnimatedSprite2D = $"../../AnimatedSprite2D"
@onready var hit_box: CollisionShape2D = $"../../CollisionShape2D"


func enter() -> void:
	print(enemy.name + str(enemy.get_rid()) + " is dead")
	hit_box.disabled = true
	enemy.velocity = Vector2.ZERO
	anim.play("death")
	await anim.animation_finished
	enemy.queue_free()
