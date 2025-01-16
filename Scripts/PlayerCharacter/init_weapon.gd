@tool

class_name WeaponController extends Node3D

@export var WEAPON_TYPE : Weapons:
	set(value):
		WEAPON_TYPE = value
		if Engine.is_editor_hint():
			load_weapon()

@export var sway_noise : NoiseTexture2D
@export var sway_speed : float = 1.2
@export var reset : bool = false
@onready var weapon_mesh : MeshInstance3D = %WeaponMesh
@onready var weapon_shadow : MeshInstance3D = %WeaponShadow
@onready var current_ammo_in_mag : int = WEAPON_TYPE.mag_size
# Called when the node enters the scene tree for the first time.
var mouse_movement : Vector2
var random_sway_x
var random_sway_y
var random_sway_amount : float
var time : float = 0.01
var idle_sway_adjustment
var idle_sway_rotation_strength
var can_shoot = true

func _ready() -> void:
	load_weapon()

func load_weapon() -> void:
	weapon_mesh.mesh = WEAPON_TYPE.mesh
	position = WEAPON_TYPE.position
	rotation_degrees = WEAPON_TYPE.rotation
	weapon_shadow.visible = WEAPON_TYPE.shadow
	scale = WEAPON_TYPE.scale
	weapon_shadow.visible = WEAPON_TYPE.shadow
	idle_sway_adjustment = WEAPON_TYPE.idle_sway_adjustment
	idle_sway_rotation_strength = WEAPON_TYPE.idle_sway_rotation_strength
	random_sway_amount = WEAPON_TYPE.random_sway_amount
# Called every frame. 'delta' is the elapsed time since the previous frame.

func sway_weapon (delta,isIdle:bool) -> void:
	if Engine.is_editor_hint():
		return
	if isIdle:
		var sway_random : float = get_sway_noise()
		var sway_random_adjusted : float = sway_random * idle_sway_adjustment
		time += delta + (sway_speed * sway_random)
		random_sway_x = sin(time * 1.5 + sway_random_adjusted) / random_sway_amount
		random_sway_y = sin(time - sway_random_adjusted) / random_sway_amount
	
		mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min,WEAPON_TYPE.sway_max)
		position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position + random_sway_x) * delta, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position + random_sway_y ) * delta, WEAPON_TYPE.sway_speed_position)
		rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation + (random_sway_y * idle_sway_rotation_strength))*delta, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation + (random_sway_x * idle_sway_rotation_strength)) * delta, WEAPON_TYPE.sway_speed_rotation)
	else:
		mouse_movement = mouse_movement.clamp(WEAPON_TYPE.sway_min,WEAPON_TYPE.sway_max)
		position.x = lerp(position.x, WEAPON_TYPE.position.x - (mouse_movement.x * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
		position.y = lerp(position.y, WEAPON_TYPE.position.y + (mouse_movement.y * WEAPON_TYPE.sway_amount_position) * delta, WEAPON_TYPE.sway_speed_position)
		rotation_degrees.y = lerp(rotation_degrees.y, WEAPON_TYPE.rotation.y + (mouse_movement.x * WEAPON_TYPE.sway_amount_rotation) *delta, WEAPON_TYPE.sway_speed_rotation)
		rotation_degrees.x = lerp(rotation_degrees.x, WEAPON_TYPE.rotation.x - (mouse_movement.y * WEAPON_TYPE.sway_amount_rotation)  * delta, WEAPON_TYPE.sway_speed_rotation)

func _input(event):
	if event.is_action_pressed("weapon1"):
		WEAPON_TYPE = load("res://Arts/Meshes/Weapons/crowbar/crowbar.tres")
		load_weapon()
	if event.is_action_pressed("weapon2"):
		WEAPON_TYPE = load("res://Arts/Meshes/Weapons/pistol/pistol.tres")
		load_weapon()
	if event is InputEventMouseMotion:
		mouse_movement = event.relative
		
func _physics_process (delta: float) -> void:
	sway_weapon(delta,true)
	#print('hello')
	
func get_sway_noise() -> float:
	var player_position : Vector3 = Vector3(0,0,0)
	if not Engine.is_editor_hint():
		player_position = GameManager.lastFramePosition
	var noise_location : float = sway_noise.noise.get_noise_2d(player_position.x,player_position.y)
	return noise_location
	
func _attack() -> void:
	
	if(!can_shoot): #|| current_ammo_in_mag <= 0 || ):
		return
	var camera = $"../.."  # Adjust this path to your camera node
	var screen_center = get_viewport().size / 2

	# Get the camera's position and direction
	var from = camera.global_transform.origin
	var direction = camera.project_ray_normal(screen_center).normalized()

	# Adjust the spawn position slightly forward from the camera
	var spawn_position = from + direction * 1.5  # Adjust the multiplier to control spawn distance

	# Instance the projectile
	var projectile_scene = preload("res://Scenes/proyectile v2.tscn")
	var projectile = projectile_scene.instantiate()

	# Set the position and direction of the projectile
	projectile.global_transform = camera.global_transform
	#projectile.direction = direction

	# Add the projectile to the scene
	can_shoot = false
	get_tree().current_scene.add_child(projectile)
	await(get_tree().create_timer(60/WEAPON_TYPE.fire_rate)).timeout
	print ('timer is finished')
	can_shoot=true
