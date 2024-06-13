extends Node3D

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_scene"):
		get_tree().reload_current_scene()	
