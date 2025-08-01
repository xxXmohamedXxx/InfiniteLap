extends CharacterBody2D  # Godot 4

@onready var camera_2d = $Camera2D
@onready var label = $Label
@onready var timer = $Timer
@onready var healthbar = $CanvasLayer/Health

var speed := 300.0  # constant target speed
var accel := 600.0
var turn_speed := 3.0
var friction := 600.0
var health = 100:
	set(value):
		health = value
		healthbar.value = health
		if health <= 0:
			gameover()
var status = []
signal oil_affected
func _physics_process(delta):
	# Show velocity in label
	# Camera zoom based on velocity length
	var velocity_len = velocity.length()
	
	label.text = str(velocity.normalized())
	if velocity_len > 250:
		camera_2d.zoom = camera_2d.zoom.move_toward(Vector2(0.7, 0.7), delta/5)
		camera_2d.offset = camera_2d.offset.lerp(velocity.normalized()*250, delta/3)
	elif velocity_len > 150:
		camera_2d.zoom = camera_2d.zoom.move_toward(Vector2(0.8, 0.8), delta/5)
		camera_2d.offset = camera_2d.offset.lerp(velocity.normalized()*160, delta/3)
	elif velocity_len > 50:
		camera_2d.zoom = camera_2d.zoom.move_toward(Vector2(0.9, 0.9), delta/5)
		camera_2d.offset = camera_2d.offset.lerp(velocity.normalized()*70, delta/3)
	else:
		camera_2d.zoom = camera_2d.zoom.move_toward(Vector2(1, 1), delta/5)
		camera_2d.offset = camera_2d.offset.lerp(Vector2.ZERO, delta)
	#
	# Handle rotation
	if Input.is_action_pressed("Left") and velocity_len > 50:
		rotation -= turn_speed * delta
	if Input.is_action_pressed("Right") and velocity_len > 50:
		rotation += turn_speed * delta

	# Movement input
	var moving = false
	var target_velocity = Vector2.ZERO
	
	if Input.is_action_pressed("Shift"):
		accel = 50
	else:
		accel = 100
	
	if Input.is_action_pressed("Forward"):
		target_velocity = Vector2.RIGHT.rotated(rotation) * speed
		moving = true
	elif Input.is_action_pressed("Backward"):
		target_velocity = Vector2.RIGHT.rotated(rotation) * -speed * 0.5
		moving = true
	
	if moving:
		var effective_accel = accel
		if Input.is_action_pressed("Left") or Input.is_action_pressed("Right"):
			effective_accel *= 8.0 # turn boost
		velocity = velocity.move_toward(target_velocity, effective_accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	move_and_slide()


		# Snap direction if angle is close to cardinal direction
	if not Input.is_action_pressed("Left") and not Input.is_action_pressed("Right"):
		var snap_threshold = deg_to_rad(15)  # tweak this angle as needed
		var angles = [
			0,                  # Right
			PI / 2,             # Down
			PI,                 # Left
			-PI / 2             # Up (or use 3*PI/2)
		]

		for target_angle in angles:
			if abs(wrapf(rotation - target_angle, -PI, PI)) < snap_threshold:
				rotation = lerp_angle(rotation, target_angle, 0.2)
				break
	move_and_slide()

func gameover():
	queue_free()


func _on_timer_timeout():
	status.erase("slippery")
	accel = 100.0
	friction = 400.0
	turn_speed = 3.0


func _on_oil_affected():
	status.append("slippery")
	accel = 50
	friction = 50
	turn_speed = 1.5
	timer.start()
