extends AnimatedSprite2D

var speed : int = 200
var direction: Vector2 = 	Vector2.ZERO


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_fire_hit_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("dano")
		# Verifica o nó pai e se ele tem o método "dmg"
		var player = body
		if player:
			Global.life -=1
			player.death()
		


func on_screen_exited() -> void:
	queue_free()
