extends AnimatedSprite2D

var speed : int = 600
var direction : int
var last_direction : int = 1


func _physics_process(delta: float) -> void:
	if direction != 0:
		last_direction = direction
		move_local_x(direction * speed * delta)
	else:
		print(last_direction)
		move_local_x(last_direction * speed * delta)


func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.


func _on_hitbox_body_entered(body: Node2D) -> void:
	queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("slimes"):
		# Acessa o nó pai do 'Area2D' para garantir que o 'slime' seja destruído
		var slime = area.get_parent()
		if slime:
			# Verifica se há um AnimatedSprite2D e toca a animação "crushed"
			if slime.has_node("AnimatedSprite2D"):
				var sprite = slime.get_node("AnimatedSprite2D")
				sprite.play("crushed")
				# Aguarda o fim da animação antes de remover o 'slime'
			
			#await get_tree().create_timer(1.0).timeout	 #PROBLEMA
			slime.queue_free()
		
	# Remove o próprio objeto que possui o hitbox
	queue_free()
