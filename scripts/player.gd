extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
## How much drift if pressing directions
@export var torque_thrust: float = 100.0


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * delta * thrust)
	if Input.is_action_pressed("move_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust*delta))
	if Input.is_action_pressed("move_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust*delta))
		
func _physics_process(delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		complete_level(body.file_path)
	if "Hazard" in body.get_groups():
		crash_sequence()

func complete_level(next_level_file: String) -> void:
	print("You win!")
	get_tree().change_scene_to_file(next_level_file)

func crash_sequence() -> void:
	print("bem")
	get_tree().reload_current_scene()
