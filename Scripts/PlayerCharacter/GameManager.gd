#GameManager.gd
extends Node

var lastFramePosition : Vector3 = Vector3.ZERO
@onready var camera3D : Camera3D = null
var player_character : Node = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera3D =  $"../.."
	print(camera3D)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
