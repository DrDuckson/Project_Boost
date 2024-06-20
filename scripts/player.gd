extends RigidBody3D

## How much vertical force to apply when moving
@export_range(750.0, 3000.0) var thrust: float = 1000.0
## How much drift if pressing directions
@export var torque_thrust: float = 100.0
var is_transitioning: bool = false

@onready var crash_audio: AudioStreamPlayer = $CrashAudio
@onready var complete_audio: AudioStreamPlayer = $CompleteAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var particles_mid: GPUParticles3D = $ParticlesMid
@onready var particles_left: GPUParticles3D = $ParticlesLeft
@onready var particles_right: GPUParticles3D = $ParticlesRight

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		apply_central_force(basis.y * thrust * delta)
		particles_mid.emitting = true
		particles_right.emitting = true
		particles_left.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		rocket_audio.stop()
		particles_mid.emitting = false
		particles_right.emitting = false
		particles_left.emitting = false
	if Input.is_action_pressed("move_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		particles_left.emitting = false
	if Input.is_action_pressed("move_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		particles_right.emitting = false

func _physics_process(_delta: float) -> void:
	pass
	
func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:	
		if "Goal" in body.get_groups():
			complete_level.call_deferred(body.file_path)
		if "Hazard" in body.get_groups():
			crash_sequence.call_deferred()

func complete_level(next_level_file: String) -> void:
	rocket_audio.stop()
	set_process(false)
	is_transitioning = true
	complete_audio.play()
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))

func crash_sequence() -> void:
	rocket_audio.stop()
	set_process(false)
	is_transitioning = true
	crash_audio.play()
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)
