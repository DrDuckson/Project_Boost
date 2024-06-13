extends RigidBody3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * delta * 1000)
	if Input.is_action_pressed("move_left"):
		apply_torque(Vector3(0.0, 0.0, 100.0*delta))
	if Input.is_action_pressed("move_right"):
		apply_torque(-Vector3(0.0, 0.0, 100.0*delta))
		
func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		print(body.name)
	if "Hazard" in body.get_groups():
		print("you hit the " + body.name + "!")
		get_tree().reload_current_scene()
