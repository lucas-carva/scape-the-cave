extends CharacterBody2D

var tiro = preload("res://cenas/tiro.tscn")
var last_direction : int

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
@export var tiros = 20
const SPEED = 200.0
const JUMP_VELOCITY = -350.0
const RUN_BOOST = 1.4

var is_dying = false
var is_shooting = false
var is_running = false

var start_position: Vector2  # Posição inicial do personagem

# Enum para os estados de animação
enum State { IDLE, WALK, RUN, JUMP, DEATH, SHOOT, RUN_SHOOT, DMG}
var current_state := State.IDLE

func _ready() -> void:
	start_position = position  # Salva a posição inicial do personagem
	Global.key = false
	play_animation()

func _physics_process(delta: float) -> void:
	var current_position = global_position  # Posição local
	var momento_tiro = tiro.instantiate() as Node2D

	if is_dying or is_shooting:
		return
	'''
	if Global.life == 0:
		death()
	'''
	
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if current_state != State.JUMP:
			current_state = State.JUMP
			play_animation()

	# Handle jump.
	if Input.is_action_just_pressed("move_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if current_state != State.JUMP:
			current_state = State.JUMP
			play_animation()

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		if Input.is_action_pressed("run"):
			is_running = true
			velocity.x = direction * SPEED * RUN_BOOST
			if current_state != State.RUN and is_on_floor():
				current_state = State.RUN
				play_animation()
		else:
			is_running = false
			if is_on_floor() and current_state != State.WALK:
				current_state = State.WALK
				play_animation()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and current_state != State.IDLE:
			current_state = State.IDLE
			play_animation()

	#verificar ultimo lado apontando
	if direction:
		last_direction = direction
		
	# Verificar se o personagem está atirando
	if Input.is_action_just_pressed("shoot") and Global.tiros > 0 and not is_shooting:
		Global.tiros -= 1
		momento_tiro.position = muzzle.global_position
		momento_tiro.direction = last_direction
		get_parent().add_child(momento_tiro)

		# Bloquear outros estados enquanto atirando
		is_shooting = true
		current_state = State.SHOOT
		play_animation()
		# Aguardar a animação terminar e desbloquear
		await $AnimatedSprite2D.animation_finished
		is_shooting = false
		# Voltar ao estado apropriado
		current_state = State.IDLE if is_on_floor() else State.JUMP
		play_animation()


			
	# Flip the character based on direction
	if direction == 1:
		$AnimatedSprite2D.scale.x = 1.75
		muzzle.global_position.x = current_position.x - 65
	elif direction == -1:
		$AnimatedSprite2D.scale.x = -1.75
		muzzle.global_position.x = current_position.x - 165


	# Move the character
	move_and_slide()

# Função para controlar as animações baseadas no estado
func play_animation():
	match current_state:
		State.IDLE:
			$AnimatedSprite2D.play("idle")
		State.WALK:
			$AnimatedSprite2D.play("walk")
		State.RUN:
			$AnimatedSprite2D.play("run")
		State.JUMP:
			$AnimatedSprite2D.play("jump")
		State.DEATH:
			$AnimatedSprite2D.play("death")
		State.SHOOT:
			$AnimatedSprite2D.play("shoot")
		State.RUN_SHOOT:
			$AnimatedSprite2D.play("run_shoot")
		State.DMG:
			$AnimatedSprite2D.play("dmg")
# Função de morte
func death():
	is_dying = true
	velocity.y = 500
	current_state = State.DEATH
	play_animation()
	await get_tree().create_timer(2.0).timeout
	position = start_position  # Reseta para a posição inicial
	print("MORREU")
	is_dying = false
	current_state = State.IDLE  # Volta para o estado de idle após a morte

# Função chamada quando o personagem colide com algo



func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.life -= 1
		#current_state = State.DMG
		death()
		
func _on_spikes_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.life -= 1
		death()

func _on_key_hitbox_body_entered(body: Node2D) -> void:
	$key.set_vi
	Global.key = true
	print("foi")
	pass # Replace with function body.


func _on_hitbox_bat_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.is_dying == false:
		Global.life -= 1
		death()
	pass # Replace with function body.


func _on_spikes_level3_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Global.life -= 1
		#current_state = State.DMG
		death()
	pass # Replace with function body.
