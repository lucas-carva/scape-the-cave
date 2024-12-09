extends Area2D

@onready var transition = get_parent().get_node("transition")
@export var next_level : String = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and !next_level == "": # and Global.key == true:
		transition.change_scene(next_level)
		
		print("proxima fase!")
	else:
		print("No scene loaded")
