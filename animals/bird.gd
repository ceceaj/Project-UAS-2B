extends CharacterBody2D

@export var fly_range : float = 8
@export var speed : int = 80

var fly_dir : Vector2

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	randomize()
	get_new_fly_dir()

func _physics_process(_delta):
	# Gerakan burung terbang
	velocity = fly_dir * speed
	
	# Ganti arah random
	if randi() % 60 == 0:
		get_new_fly_dir()
	
	# Gerak
	move_and_slide()
	
	# Kalau nabrak, balik arah
	if is_on_wall():
		fly_dir.x *= -1
	if is_on_ceiling() or is_on_floor():
		fly_dir.y *= -1
	
	# Flip sprite kanan/kiri
	if fly_dir.x < 0:
		sprite_2d.flip_h = true
	elif fly_dir.x > 0:
		sprite_2d.flip_h = false
	
	# Animasi terbang
	animation_player.play("fly")
	
	# Suara burung random
	if randi() % 500 == 0:
		audio_stream_player_2d.play()

func get_new_fly_dir():
	fly_dir = Vector2(
		randf_range(-fly_range, fly_range),
		randf_range(-fly_range, fly_range)
	).normalized()
