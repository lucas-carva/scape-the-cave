extends AnimatedSprite2D

var speed : int = 600
var direction : int


func _physics_process(delta: float) -> void:
	if direction != 0:
		move_local_x(direction * speed * delta)
	else:
		move_local_x(direction * speed * delta)



func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.


func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("morcegos"):
		print("bat")
		# Verifica o nó pai e se ele tem o método "dmg"
		var bat = body
		if bat:
			bat.life -=1
			if bat.life > 0:
				bat.dmg()
			bat.die()
		else:
			print("O nó pai não possui o método 'dmg'")
	
	if body.is_in_group("demon"):
		print("deabo")
		# Verifica o nó pai e se ele tem o método "dmg"
		var demon = body
		if demon:
			demon.life -=1
			if demon.life > 0:
				demon.dmg()
			demon.die()
		else:
			print("O nó pai não possui o método 'dmg'")
	print("body")
	queue_free()


func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("slimes"):
		print("slime")
		# Acessa o nó pai do 'Area2D' para garantir que o 'slime' seja destruído
		var slime = area.get_parent()
		if slime:
			slime.life -=1
			if slime.life > 0:
				slime.dmg()
			slime.die()
			
		
	# Remove o próprio objeto que possui o hitbox
	print("area")
	queue_free()
