extends CharacterBody2D

@export var SPEED = 100.0
@export var direction := -1
@export var life = 3
var timer := 0.0  # Para contar o tempo

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var tiro = preload("res://cenas/tiro.tscn")

func _physics_process(delta: float) -> void:
	
	# Detecta parede com RayCast2D
	if $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		
		# Só vira se não for o jogador
		if not collider.is_in_group("player"):
			direction *= -1
		
	if not is_on_floor():
		velocity.y += gravity * delta
		direction = -direction

	# Aplica a velocidade e o movimento
	velocity.x = direction * SPEED

	# Atualiza o flip do sprite de acordo com a direção
	if direction == -1:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

	move_and_slide()
	
func dmg():
	$AnimatedSprite2D.play("dmg")
	await get_tree().create_timer(0.5).timeout	 
	$AnimatedSprite2D.play("walk")



func die():
	if life <= 0:
		SPEED = 10
		$AnimatedSprite2D.play("crushed")
		await get_tree().create_timer(1.0).timeout	 
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
