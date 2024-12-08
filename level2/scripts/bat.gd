extends CharacterBody2D

# ConfiguraÃ§Ãµes do inimigo
@export var speed: float = 100.0       # Velocidade do inimigo
@export var range: float = 100.0      # DistÃ¢ncia de ida e volta
@export var direction: Vector2 = Vector2.RIGHT  # DireÃ§Ã£o inicial do movimento
@export var life = 3
var is_dying = false
# VariÃ¡veis internas
var start_position: Vector2
var target_position: Vector2

func _ready():
	# Salva a posiÃ§Ã£o inicial e calcula o alvo
	start_position = global_position
	target_position = start_position + direction * range

func _physics_process(delta):
	# Atualiza a velocidade com base na direÃ§Ã£o
	velocity = direction * speed

	# Move o inimigo
	move_and_slide()

	# Verifica se atingiu o limite e inverte a direÃ§Ã£o
	if global_position.distance_to(target_position) <= 1.0:
		direction = -direction  # Inverte a direÃ§Ã£o
		target_position = start_position if direction == -direction else start_position + direction * range
	
	if direction == Vector2.RIGHT:
		$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.flip_h = true

func dmg():
	$AnimatedSprite2D.play("dmg")
	await get_tree().create_timer(1).timeout	 
	$AnimatedSprite2D.play("fly")

func die():
	if life <= 0:
		var is_dying = true
		velocity = direction * 10
		velocity.y = 300
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(1.0).timeout	 
		queue_free()
		
