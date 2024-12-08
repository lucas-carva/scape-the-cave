extends Control

@onready var key_counter = $container/key_container/keys_counter as Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if(Global.key == true):
		key_counter.text = "x1"
	else:
		key_counter.text = "x0"

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
