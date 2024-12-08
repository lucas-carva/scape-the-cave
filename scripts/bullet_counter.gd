extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Atualiza o texto do Label sempre que a variável global "tiros" mudar
	text = " " +  str(Global.tiros)
