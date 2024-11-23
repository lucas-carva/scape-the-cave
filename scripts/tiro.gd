extends AnimatedSprite2D

var speed : int = 600
var direction : int

func _physics_process(delta: float) -> void:
	move_local_x(direction * speed * delta)

func _on_timer_timeout() -> void:
	queue_free() # Replace with function body.


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("body")
	queue_free()
	pass # Replace with function body.


func _on_hitbox_area_entered(area: Area2D) -> void:
	queue_free()
	print("area")
