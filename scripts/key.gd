extends Sprite2D  # Pode ser substituído por Sprite2D, TextureRect, etc.

@export var float_amplitude: float = 10.0  # Distância máxima para cima/baixo
@export var float_speed: float = 2.0  # Velocidade da flutuação
var initial_position: Vector2  # Posição inicial do item

func _ready() -> void:
	initial_position = position  # Salva a posição inicial

func _process(delta: float) -> void:
	# Atualiza a posição vertical com uma função senoidal
	position.y = initial_position.y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amplitude


func _on_key_hitbox_body_entered(body: Node2D) -> void:
	 # Verifica se o corpo que entrou é o player (ou o grupo certo)
	if body.is_in_group("player"):  # Certifique-se de que o Player está no grupo "player"
		Global.key = true  # Define que a chave foi coletada
		print("Chave coletada!")  # Mensagem no console
		queue_free()  # Remove o nó da chave
