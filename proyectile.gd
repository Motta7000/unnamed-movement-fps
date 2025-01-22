extends RigidBody3D

@export var speed: float = 50.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO
@onready var mesh = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var ray = $RayCast3D
@export var damage: int = 1    # Damage dealt by the projectile
@onready var timerOn = true

var hit_timer: Timer  # Declare a timer variable
var trail: MeshInstance3D  # MeshInstance3D for the bullet trail effect
var trail_mesh: ArrayMesh  # ArrayMesh for the trail
var last_position: Vector3  # Keep track of the last position for the trail

func _ready() -> void:
	# Set the linear velocity to move the projectile
	gravity_scale = 0
	linear_velocity = direction * speed

	# Create and configure the timer
	hit_timer = Timer.new()
	add_child(hit_timer)  # Add the timer to the scene tree
	hit_timer.wait_time = 0.0000001  # Set the timer duration (to avoid immediate self-damage)
	hit_timer.one_shot = true  # Make the timer one-shot
	
	# Connect the timeout signal to the function
	var timeout_callable = Callable(self, "_on_timer_timeout")
	hit_timer.connect("timeout", timeout_callable)
	hit_timer.start()

	# Create and configure the trail (MeshInstance3D)
	trail = MeshInstance3D.new()
	add_child(trail)  # Add the trail to the scene tree
	
	# Create the mesh for the trail (ArrayMesh)
	trail_mesh = ArrayMesh.new()
	var arrays = Array()
	arrays.resize(2)
	trail_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	trail.mesh = trail_mesh
	if trail_mesh != null and trail_mesh.get_surface_count() > 0:
		print("Mesh is valid and has surfaces.")
	else:
		print("Mesh is invalid or has no surfaces.")
	# Initialize the trail with the current position
	last_position = global_transform.origin

	# Optional: Destroy the projectile after 25 seconds
	await get_tree().create_timer(25).timeout
	queue_free()

func _process(delta) -> void:
	# Update the trail path by creating a new line from last position to the current position
	var arrays = trail_mesh.surface_get_arrays(0)
	if  trail_mesh.get_surface_count() > 0:
		var vertices = arrays[Mesh.ARRAY_VERTEX]
	# Add the new positions (current and last)
		vertices.append(global_transform.origin)
		vertices.append(last_position)
	
	# Update the array in the mesh
		arrays[Mesh.ARRAY_VERTEX] = vertices
		trail_mesh.surface_set_arrays(0, arrays)

	# Update the last position to the current position
		last_position = global_transform.origin
	#else:
		#print("No vertex data in mesh")

	if ray.is_colliding() and !timerOn:
		var collider = ray.get_collider()  # Get the node hit by the ray
		while collider:
			if collider.has_method("TakeDamage"):
				collider.TakeDamage(damage)  # Call the TakeDamage method
				break
			collider = collider.get_parent()  # Move up the tree
		# Handle projectile behavior after collision
		mesh.visible = false
		linear_velocity = Vector3.ZERO
		# Start the timer to delay the removal of the projectile

func _on_timer_timeout() -> void:
	#print('Bullet can hit something now')
	timerOn = false
