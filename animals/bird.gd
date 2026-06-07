extends CharacterBody2D

@export var speed : float = 50.0
@export var change_direction_time : float = 2.0

var fly_dir : Vector2
var timer : float = 0.0

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	randomize()
	get_new_direction()
	animation_player.play("fly")

func _physics_process(delta):

	timer += delta

	# Ganti arah secara acak setiap beberapa detik
	if timer >= change_direction_time:
		get_new_direction()
		timer = 0.0

	velocity = fly_dir * speed
	move_and_slide()

	# Jika menabrak sesuatu, ganti arah
	if get_slide_collision_count() > 0:
		get_new_direction()
		timer = 0.0

	# Flip sprite
	if fly_dir.x < 0:
		sprite_2d.flip_h = true
	elif fly_dir.x > 0:
		sprite_2d.flip_h = false

	# Suara burung acak
	if randf() < 0.15 * delta:
		if !audio_stream_player_2d.playing:
			audio_stream_player_2d.play()

func get_new_direction():
	var angle = randf_range(0.0, TAU)

	fly_dir = Vector2(
		cos(angle),
		sin(angle)
	).normalized()

	change_direction_time = randf_range(1.5, 3.5)
