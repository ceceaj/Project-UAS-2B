extends CharacterBody2D

#Variables for controlling player movement
var input_vector = Vector2.ZERO
const speed : float = 80.0

#variables for controlling player animations
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var footstep_player : AudioStreamPlayer = $FootstepPlayer
var direction : String = "down_idle"

# Footstep timer — interval antar langkah (detik)
var footstep_timer : float = 0.0
const FOOTSTEP_INTERVAL : float = 0.38


func _ready():
	anim.play("down_idle")

#player physics
func _physics_process(delta):
	move_player()
	idle_animations()
	walk_animations()
	play_footstep(delta)
	move_and_slide()


#----- ACTIONS -----
#--------------------
func move_player():
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		velocity = input_vector * speed
	else:
		velocity = Vector2.ZERO


#----- FOOTSTEP AUDIO -----
#--------------------------
func play_footstep(delta: float) -> void:
	if velocity != Vector2.ZERO:
		footstep_timer -= delta
		if footstep_timer <= 0.0:
			footstep_player.play()
			footstep_timer = FOOTSTEP_INTERVAL
	else:
		footstep_timer = 0.0
		if footstep_player.playing:
			footstep_player.stop()


#----- ANIMATIONS -----
#----------------------


#Sets up walking animations for player character
func walk_animations():
	if velocity.x < 0:
		anim.play("walk_left")
		direction = "left"
	elif velocity.x > 0:
		anim.play("walk_right")
		direction = "right"
	elif velocity.y < 0:
		anim.play("walk_up")
		direction = "up"
	elif velocity.y > 0:
		anim.play("walk_down")
		direction = "down"
	else:
		pass


#Sets up idle animations for when the player isn't moving
func idle_animations():
	if velocity == Vector2.ZERO and direction == "left":
			anim.play("left_idle")
	elif velocity == Vector2.ZERO and direction == "right":
			anim.play("right_idle")
	elif velocity == Vector2.ZERO and direction == "up":
			anim.play("up_idle")
	elif velocity == Vector2.ZERO and direction == "down":
			anim.play("down_idle")
	else:
		pass
