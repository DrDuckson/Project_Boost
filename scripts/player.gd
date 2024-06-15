extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
## How much drift if pressing directions
@export var torque_thrust: float = 100.0
var is_transitioning: bool = false

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
	if is_transitioning == false:	
		if "Goal" in body.get_groups():
			complete_level.call_deferred(body.file_path)
		if "Hazard" in body.get_groups():
			crash_sequence.call_deferred()

func complete_level(next_level_file: String) -> void:
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))

func crash_sequence() -> void:
	set_process(false)
	is_transitioning = true
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)
