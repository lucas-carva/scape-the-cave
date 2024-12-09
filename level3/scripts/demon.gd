extends CharacterBody2D

# Configurações do inimigo
@export var speed: float = 100.0       # Velocidade do inimigo
@export var range: float = 300.0      # Distância de ida e volta
@export var direction: Vector2 = Vector2.RIGHT  # Direção inicial do movimento
@export var life = 50
@export var fire_rate: float = 1    # Intervalo entre disparos (em segundos)
var is_dying = false
var fireball = preload("res://level3/cenas/fireball.tscn")

# Variáveis internas
var start_position: Vector2
var target_position: Vector2
var can_shoot: bool = true  # Controle para evitar disparos contínuos

@onready var timer =  $"../Timer"
@onready var ray_cast = $RayCast2D
@export var ammo : PackedScene
@onready var muzzleDemon : Marker2D = $MuzzleDemon  # Ponto de disparo\

var player

func _ready():
	
	var player = get_parent().get_node("player")
	# Salva a posição inicial e calcula o alvo
	start_position = global_position
	target_position = start_position + direction * range

func _physics_process(delta):
	
	_aim()
	_check_player_collision()
	# Atualiza a velocidade com base na direção
	velocity = direction * speed

	# Move o inimigo
	move_and_slide()

	# Verifica se atingiu o limite e inverte a direção
	if global_position.distance_to(target_position) <= 1.0:
		direction = -direction  # Inverte a direção
		target_position = start_position if direction == -direction else start_position + direction * range
	
	# Ajusta a orientação do sprite
	$AnimatedSprite2D.flip_h = direction == Vector2.RIGHT

func _aim():
	if player:
		ray_cast.target_position = to_local(player.position)
	else:
		print("Player node not found!")
		
func _check_player_collision():
	pass
	
func dmg():
	$AnimatedSprite2D.play("dmg")
	await get_tree().create_timer(0.25).timeout	 
	$AnimatedSprite2D.play("idle")

func die():
	if life <= 0:
		is_dying = true
		velocity = direction * 10
		velocity.y = 300
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(1.5).timeout	 
		queue_free()
		
func _on_player_radar_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"): # Impede disparos contínuos
		# Cria o projétil
		var fire_instant = fireball.instantiate() as Node2D
		# Define a posição inicial do projétil
		if muzzleDemon:
			fire_instant.position = muzzleDemon.global_position
		else:
			print("Boss não encontrado!")
		#fire_instant.direction = Vector2.RIGHT
		# Direciona o projétil para o jogador
		if muzzleDemon:
			fire_instant.direction = -(body.global_position - muzzleDemon.global_position).normalized()
		else:
			print("pinto")
		
		# Adiciona o projétil à cena
		get_parent().add_child(fire_instant)
		$AnimatedSprite2D.play("attack")  # Reproduz a animação de disparo
		
		# Espera o tempo do intervalo de disparo antes de permitir outro disparo
