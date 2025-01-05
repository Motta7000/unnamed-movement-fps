extends RigidBody3D

@export var speed: float = 50.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO
@onready var mesh = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var ray = $RayCast3D

func _ready() -> void:
	# Set the linear velocity to move the projectile
	gravity_scale = 0
	linear_velocity = direction * speed

	# Optional: Destroy the projectile after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta) -> void:
	# Handle collision with another body
	if ray.is_colliding():
		print("Projectile hit")
		mesh.visible = false
		linear_velocity = Vector3.ZERO
		await get_tree().create_timer(1.0).timeout
		queue_free()


func _on_timer_timeout() -> void:
	queue_free()
