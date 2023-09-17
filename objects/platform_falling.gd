extends Node3D

@export var fallDelay := 0.5

var falling := false
var gravity := 0.0
var fallTimer = Timer.new()

func _process(delta):
	scale = scale.lerp(Vector3(1, 1, 1), delta * 10) # Animate scale
	
	position.y -= gravity * delta
	
	if position.y < -10:
		queue_free() # Remove platform if below threshold
	
	if falling:
		gravity += 0.25


func _on_body_entered(_body):
	# time left = 0 means either the timer is finished, or the timer hasn't started
	if !falling and fallTimer.time_left == 0:
		Audio.play("res://sounds/trap_landing.wav") # Play sound
		scale = Vector3(1.1, 1, 1.1)
		startTimer()

func startTimer() -> void:
	fallTimer.connect("timeout", timerDone)
	fallTimer.wait_time = fallDelay
	fallTimer.one_shot = true
	add_child(fallTimer)
	fallTimer.start()

func timerDone() -> void:
	Audio.play("res://sounds/fall.ogg") # Play sound
	scale = Vector3(1.25, 1, 1.25) # Animate scale
	falling = true
