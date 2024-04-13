extends PointLight2D
class_name BodyLight

@export var initial_light_scale : float = 0.6
@export var minimum_light_scale : float = 0.4
@export var maximum_light_scale : float = 0.75
@export var fading_rate : float = 0.05
@export var maximum_quota_light_queue : float = 2.0

var light_prepare_to_add : float = 0.0


func _ready() -> void:
	texture_scale = initial_light_scale


func _process(delta: float) -> void:
	if light_prepare_to_add > 0:
		texture_scale += delta * fading_rate * 4
		light_prepare_to_add -= delta * fading_rate * 4
		if texture_scale > maximum_light_scale:
			texture_scale = maximum_light_scale
	elif texture_scale > minimum_light_scale:
		texture_scale -= delta * fading_rate


func grow_light(amount : float):
	print("growing " + str(amount) + " lights")
	light_prepare_to_add += amount
	if light_prepare_to_add > maximum_quota_light_queue:
		light_prepare_to_add = maximum_quota_light_queue
	pass
