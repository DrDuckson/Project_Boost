extends Node3D

@onready var death_zone = $DeathZone

func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_scene"):
		get_tree().reload_current_scene()
