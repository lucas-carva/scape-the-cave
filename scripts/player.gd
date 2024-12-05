extends CharacterBody2D

var tiro = preload("res://cenas/tiro.tscn")

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var muzzle : Marker2D = $Muzzle
@export var tiros = 20
const SPEED = 200.0
const JUMP_VELOCITY = -320.0
const RUN_BOOST = 1.4

var is_dying = false
var start_position: Vector2  # Posição inicial do personagem

# Enum para os estados de animação
enum State { IDLE, WALK, RUN, JUMP, DEATH, SHOOT, RUN_SHOOT }
var current_state := State.IDLE
func _ready() -> void:
	start_position = position  # Salva a posição inicial do personagem
	play_animation()

func _physics_process(delta: float) -> void:
	var current_position = global_position  # Posição local
	var momento_tiro = tiro.instantiate() as Node2D

	if is_dying:
		return
	
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
		if Input.is_action_pressed("run") and is_on_floor():
			velocity.x = direction * SPEED * RUN_BOOST
			if current_state != State.RUN:
				current_state = State.RUN
				play_animation()
		else:
			if is_on_floor() and current_state != State.WALK:
				current_state = State.WALK
				play_animation()
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and current_state != State.IDLE:
			current_state = State.IDLE
			play_animation()

	# Verificar se o personagem está atirando
	if Input.is_action_just_pressed("shoot") and tiros > 0:
		tiros -=1
		momento_tiro.position = muzzle.global_position
		momento_tiro.direction = direction
		get_parent().add_child(momento_tiro)
		if current_state != State.SHOOT:
			current_state = State.SHOOT
			await get_tree().create_timer(1.0).timeout
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
# Função de morte
func death():
	is_dying = true
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
		death()

func _on_spikes_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		death()
