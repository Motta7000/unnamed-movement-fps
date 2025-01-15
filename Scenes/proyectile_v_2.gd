extends RayCast3D

@export var damage: int = 1    # Damage dealt by the projectile
@export var speed := 50.0
func _physics_process(delta: float) -> void:
	position += global_basis * Vector3.FORWARD * speed * delta
	target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	if is_colliding():
		global_position = get_collision_point()
		set_physics_process(false)
		var collider = get_collider()  # Get the node hit by the ray
		while collider:
			if collider.has_method("TakeDamage"):
				collider.TakeDamage(damage)  # Call the TakeDamage method
				break
			collider = collider.get_parent()  # Move up the tree
		# Handle projectile behavior after collision
		cleanup()
func cleanup () -> void:
	queue_free()
