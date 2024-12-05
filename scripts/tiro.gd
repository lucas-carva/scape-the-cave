extends AnimatedSprite2D

var speed : int = 600
var direction : int
var last_direction : int = 1


func _physics_process(delta: float) -> void:
	if direction != 0:
		last_direction = direction
		move_local_x(direction * speed * delta)
	else:
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
			slime.life -=1
			if slime.life > 0:
				slime.dmg()
			slime.die()
		
	# Remove o próprio objeto que possui o hitbox
	queue_free()
