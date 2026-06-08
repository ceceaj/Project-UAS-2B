extends CharacterBody2D

@export var wander_range: float = 5
@export var speed: int = 5
@export var popup_scene_path: String = "res://popup games/cow_interaction_popup.tscn"
const WARNING_POPUP_SCENE := preload("res://popup peringatan/ui_peringatan.tscn")

var currentPos: Vector2
var wanderPos: Vector2
var popup_is_open: bool = false
var player_inside_area: bool = false
var cow_interaction_player: AudioStreamPlayer

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var interaction_area = $InteractionArea

func _ready():
	currentPos = position
	cow_interaction_player = AudioStreamPlayer.new()
	cow_interaction_player.name = "CowInteractionAudio"
	cow_interaction_player.bus = "Master"
	cow_interaction_player.volume_db = 2.0
	cow_interaction_player.stream = create_cow_moo_stream()
	add_child(cow_interaction_player)
	
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

func _physics_process(_delta):
	velocity = wanderPos * speed
	
	if randi() % 60 == 0:
		get_new_wander_dir()
	
	if move_and_slide():
		wanderPos = Vector2(-wanderPos.x, -wanderPos.y)
	
	if wanderPos.x < 0:
		sprite_2d.set_flip_h(true)
		animation_player.play("cow")
	elif wanderPos.x > 0:
		sprite_2d.set_flip_h(false)
		animation_player.play("cow")
	
	if randi() % 600 == 0 and audio_stream_player_2d.stream != null:
		audio_stream_player_2d.play()

func get_new_wander_dir():
	var target_vector = Vector2(
		randf_range(-wander_range, wander_range),
		randf_range(-wander_range, wander_range)
	)
	wanderPos = target_vector

func play_npc_sound() -> void:
	if cow_interaction_player != null and cow_interaction_player.stream != null:
		cow_interaction_player.stop()
		cow_interaction_player.play()
		return

	if audio_stream_player_2d == null:
		push_warning("AudioStreamPlayer2D sapi tidak ditemukan")
		return
	if audio_stream_player_2d.stream == null:
		push_warning("Stream audio sapi belum terpasang")
		return
	audio_stream_player_2d.stop()
	audio_stream_player_2d.play()

func create_cow_moo_stream() -> AudioStreamWAV:
	var sample_rate := 22050
	var duration := 1.15
	var sample_count := int(sample_rate * duration)
	var data := PackedByteArray()
	var phase := 0.0

	data.resize(sample_count * 2)

	for i in range(sample_count):
		var t := float(i) / float(sample_rate)
		var progress := t / duration
		var freq := lerpf(135.0, 72.0, progress) + sin(TAU * 4.0 * t) * 6.0
		var envelope := 1.0

		if progress < 0.08:
			envelope = progress / 0.08
		elif progress > 0.86:
			envelope = (1.0 - progress) / 0.14

		envelope = clampf(envelope, 0.0, 1.0)
		phase += TAU * freq / float(sample_rate)

		var tone := sin(phase) * 0.72
		tone += sin(phase * 2.0) * 0.18
		tone += sin(phase * 0.5) * 0.16

		var sample := int(clampf(tone * envelope * 19000.0, -32768.0, 32767.0))
		data.encode_s16(i * 2, sample)

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = sample_rate
	stream.stereo = false
	stream.data = data
	return stream

func _on_interaction_area_body_entered(body):
	print("Yang masuk area sapi: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = true
		play_npc_sound()
		show_interaction_popup()

func _on_interaction_area_body_exited(body):
	print("Yang keluar area sapi: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = false
		popup_is_open = false

func show_interaction_popup():
	if popup_is_open:
		return

	if !DataGame.kelinci_selesai:
		var warning_popup = WARNING_POPUP_SCENE.instantiate()
		get_tree().root.add_child(warning_popup)
		warning_popup.tampilkan_popup("Kamu harus menyelesaikan kuis kelinci terlebih dahulu!")

		popup_is_open = true
		warning_popup.tree_exited.connect(_on_popup_closed)
		return
	
	var popup_scene = load(popup_scene_path)
	
	if popup_scene == null:
		print("Popup scene tidak ditemukan. Cek path: ", popup_scene_path)
		return
	
	var popup_instance = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup_instance)
	
	popup_is_open = true
	popup_instance.tree_exited.connect(_on_popup_closed)

func _on_popup_closed():
	if player_inside_area:
		popup_is_open = true
	else:
		popup_is_open = false
