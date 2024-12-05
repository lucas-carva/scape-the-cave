extends CharacterBody2D

const grupo_inimigo = "inimigos"

@export var SPEED = 100.0
@export var direction := -1
@export var life = 3
var timer := 0.0  # Para contar o tempo

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
	
func die():
	if life <= 0:
		SPEED = 10
		$AnimatedSprite2D.play("crushed")
		await get_tree().create_timer(1.0).timeout	 #PROBLEMA
		queue_free()


'''
	# Se o temporizador atingir o tempo especificado, alterna a direção
	if timer >= DIRECTION_TIME:
		direction = -direction  # Inverte a direção
		timer = 0.0  # Reseta o temporizador
'''	
	# Handle jump.

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
