extends RigidBody3D

@export var speed: float = 50.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO

func _ready() -> void:
	# Set the linear velocity to move the projectile
	gravity_scale = 0
	linear_velocity = direction * speed

	# Optional: Destroy the projectile after 5 seconds
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _on_body_entered(body: Node) -> void:
	# Handle collision with another body
	print("Projectile hit:", body.name)
	queue_free()
