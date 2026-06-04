extends CharacterBody2D

@export var speed : int = 40
var dir : int = 1

@onready var sprite_2d = $Sprite2D
@onready var animation_player = $AnimationPlayer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

func _ready():
	randomize()

func _physics_process(delta):
	# 1. GERAK MAJU (Gravitasi dihapus karena ini game Top-Down)
	velocity.x = dir * speed
	velocity.y = 0 # Mengunci posisi Y agar tidak merosot ke bawah
	
	move_and_slide()

	# 2. BALIK ARAH (Menabrak pagar/dinding)
	if is_on_wall():
		dir *= -1

	# 3. FLIP SPRITE (Sudah benar maju ke depan)
	if dir < 0:
		sprite_2d.flip_h = false  # Saat bergerak ke kiri
	else:
		sprite_2d.flip_h = true   # Saat bergerak ke kanan

	# 4. ANIMASI KAKI BERGERAK
	if velocity.x != 0:
		animation_player.play("elephant")
	else:
		animation_player.play("RESET")

	# 5. SUARA RANDOM
	if randi() % 400 == 0:
		play_elephant_sound()

func play_elephant_sound():
	if !audio_stream_player_2d.playing:
		audio_stream_player_2d.play()
