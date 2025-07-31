extends CharacterBody2D  # Godot 4

var speed := 0.0
var max_speed := 200.0
var accel := 600.0
var friction := 500.0
var turn_speed := 3.0

func _physics_process(delta):
	# Accelerate forward/back
	if Input.is_action_pressed("Forward"):
		speed += accel * delta
	elif Input.is_action_pressed("Backward"):
		speed -= accel * .5 * delta
	else:
		# Apply friction
		if speed > 0:
			speed = max(speed - friction * delta, 0)
		elif speed < 0:
			speed = min(speed + friction * delta, 0)

	speed = clamp(speed, -max_speed, max_speed)

	# Rotate left/right
	if Input.is_action_pressed("Left"):
		rotation -= turn_speed * delta
	if Input.is_action_pressed("Right"):
		rotation += turn_speed * delta

	# Move in direction car is facing
	velocity = Vector2.RIGHT.rotated(rotation) * speed
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
