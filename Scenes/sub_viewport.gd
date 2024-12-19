extends SubViewport

var screen_size : Vector2

#called when the node neters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_window().size
	size = screen_size
	
#Called every frame.
func _process(delta: float) -> void:
	pass
