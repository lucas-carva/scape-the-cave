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
