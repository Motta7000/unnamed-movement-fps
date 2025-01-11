#GameManager.gd
extends Node

var lastFramePosition : Vector3 = Vector3.ZERO
@onready var camera3D : Camera3D = null
var player_character : Node = null
var slow_motion_timer : Timer = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera3D =  $"../.."  # Adjust this path to your camera node
	print(camera3D)
	
	slow_motion_timer = Timer.new()
	slow_motion_timer.one_shot = false
	slow_motion_timer.paused = true
	slow_motion_timer.connect('timeout', _on_slow_motion_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func enemy_game_ended() -> void:
	# Add 3 seconds to the slow-motion timer
	#slow_motion_timer.wait_time += 3.0
	print('enemy down')
	# If the timer is not running, start it
	#if not slow_motion_timer.is_stopped():
	#	slow_motion_timer.start()

	# Apply slow motion by adjusting the time scale
	#Engine.time_scale = 0.5  # Adjust this value to control the slow-motion effect
func _on_slow_motion_timeout() -> void:
	# Reset the time scale to normal when the timer finishes
	Engine.time_scale = 1.0
	slow_motion_timer.stop()
	slow_motion_timer.wait_time = 0.0
	
	
