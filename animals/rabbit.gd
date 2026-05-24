extends CharacterBody2D

@export var speed : int = 50
@export var jump_force : int = -180
@export var gravity : int = 500

var dir : int = 1

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func _ready():
	randomize()


func _physics_process(delta):

	# GRAVITY
	if !is_on_floor():
		velocity.y += gravity * delta

	# GERAK KELINCI
	velocity.x = dir * speed

	# LOMPAT RANDOM
	if is_on_floor():
		if randi() % 100 == 0:
			velocity.y = jump_force

			# SUARA LOMPAT
			if !audio_stream_player_2d.playing:
				audio_stream_player_2d.play()

	# GERAK
	move_and_slide()

	# BALIK ARAH KALAU NABRAK
	if is_on_wall():
		dir *= -1

	# FLIP SPRITE
	if dir < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

	# ANIMASI
	if !is_on_floor():
		animation_player.play("jump")
	else:
		animation_player.play("walk")
