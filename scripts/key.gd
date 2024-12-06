extends Sprite2D  # Pode ser substituído por Sprite2D, TextureRect, etc.

@export var float_amplitude: float = 10.0  # Distância máxima para cima/baixo
@export var float_speed: float = 2.0  # Velocidade da flutuação
var initial_position: Vector2  # Posição inicial do item

func _ready() -> void:
	initial_position = position  # Salva a posição inicial

func _process(delta: float) -> void:
	# Atualiza a posição vertical com uma função senoidal
	position.y = initial_position.y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude
