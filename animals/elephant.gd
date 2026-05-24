extends CharacterBody2D

@export var speed : int = 40

var dir : int = 1

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func _ready():
	randomize()

func _physics_process(delta):

	# GERAK
	velocity.x = dir * speed
	move_and_slide()

	# BALIK ARAH
	if is_on_wall():
		dir *= -1

	# FLIP SPRITE
	if dir < 0:
		sprite_2d.flip_h = true
	else:
		sprite_2d.flip_h = false

	# ANIMASI
	animation_player.play("walk")

	# SUARA RANDOM
	if randi() % 400 == 0:
		play_elephant_sound()


func play_elephant_sound():

	if !audio_stream_player_2d.playing:
		audio_stream_player_2d.play()
