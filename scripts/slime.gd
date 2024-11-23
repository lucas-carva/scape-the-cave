extends CharacterBody2D

const grupo_inimigo = "inimigos"

@export var SPEED = 100.0
@export var direction := -1
var timer := 0.0  # Para contar o tempo
@export var DIRECTION_TIME = 3.0  # Tempo para andar em uma direção (em segundos)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var tiro = preload("res://cenas/tiro.tscn")

func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity.y += gravity * delta
		direction = -direction
		
	velocity.x = direction * SPEED
	
	timer += delta

	# Aplica a velocidade e o movimento
	velocity.x = direction * SPEED

	# Atualiza o flip do sprite de acordo com a direção
	if direction == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
	
	
'''
	# Se o temporizador atingir o tempo especificado, alterna a direção
	if timer >= DIRECTION_TIME:
		direction = -direction  # Inverte a direção
		timer = 0.0  # Reseta o temporizador
'''	
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
