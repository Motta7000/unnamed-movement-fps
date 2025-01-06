extends RigidBody3D

@export var speed: float = 50.0  # Speed of the projectile
var direction: Vector3 = Vector3.ZERO
@onready var mesh = $MeshInstance3D
@onready var collision_shape = $CollisionShape3D
@onready var ray = $RayCast3D
@export var damage: int = 1    # Damage dealt by the projectile
@onready var timerOn = true

var hit_timer: Timer  # Declare a timer variable

func _ready() -> void:
	# Set the linear velocity to move the projectile
	gravity_scale = 0
	linear_velocity = direction * speed

	# Create and configure the timer
	hit_timer = Timer.new()
	add_child(hit_timer)  # Add the timer to the scene tree
	hit_timer.wait_time = 0.3 # Set the timer duration (to avoid immediate self-damage)
	hit_timer.one_shot = true  # Make the timer one-shot
	
	# Connect the timeout signal to the function
	var timeout_callable = Callable(self, "_on_timer_timeout")
	hit_timer.connect("timeout", timeout_callable)
	hit_timer.start()
	# Optional: Destroy the projectile after 5 seconds
	await get_tree().create_timer(25).timeout
	queue_free()

func _process(delta) -> void:
	# Handle collision with another body
	if ray.is_colliding() and !timerOn:  # Ensure the timer isn't active
		var collider = ray.get_collider()  # Get the object hit by the ray
		if collider and collider.has_method("TakeDamage"):
			collider.TakeDamage(damage)  # Call the TakeDamage method with damage value

		# Handle projectile behavior after collision
		mesh.visible = false
		linear_velocity = Vector3.ZERO

		# Start the timer to delay the removal of the projectile

func _on_timer_timeout() -> void:
	print('Bullet timed out')
	timerOn = false
