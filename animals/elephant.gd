extends CharacterBody2D

@export var wander_range: float = 5
@export var speed: int = 5
@export var popup_scene_path: String = "res://popup games/gajah_interaction_popup.tscn"
const WARNING_POPUP_SCENE := preload("res://popup peringatan/ui_peringatan.tscn")

var currentPos: Vector2
var wanderPos: Vector2
var popup_is_open: bool = false
var player_inside_area: bool = false

@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var interaction_area = $InteractionArea

func _ready():
	currentPos = position
	randomize()
	
	interaction_area.body_entered.connect(_on_interaction_area_body_entered)
	interaction_area.body_exited.connect(_on_interaction_area_body_exited)

	print("Script gajah aktif")

func _physics_process(_delta):
	velocity = wanderPos * speed
	
	if randi() % 60 == 0:
		get_new_wander_dir()
	
	if move_and_slide():
		wanderPos = Vector2(-wanderPos.x, -wanderPos.y)
	
	if wanderPos.x < 0:
		sprite_2d.set_flip_h(true)
		if animation_player.has_animation("elephant"):
			animation_player.play("elephant")
	elif wanderPos.x > 0:
		sprite_2d.set_flip_h(false)
		if animation_player.has_animation("elephant"):
			animation_player.play("elephant")
	
	if randi() % 600 == 0:
		if audio_stream_player_2d != null:
			audio_stream_player_2d.play()

func get_new_wander_dir():
	var target_vector = Vector2(
		randf_range(-wander_range, wander_range),
		randf_range(-wander_range, wander_range)
	)
	wanderPos = target_vector

func play_npc_sound() -> void:
	var sound_handler = get_node_or_null("/root/SoundHandler")
	if sound_handler != null and sound_handler.play_npc_sound("gajah"):
		return

	if audio_stream_player_2d == null:
		push_warning("AudioStreamPlayer2D gajah tidak ditemukan")
		return
	if audio_stream_player_2d.stream == null:
		push_warning("Stream audio gajah belum terpasang")
		return
	audio_stream_player_2d.stop()
	audio_stream_player_2d.play()

func _on_interaction_area_body_entered(body):
	print("Yang masuk area gajah: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = true
		play_npc_sound()
		show_interaction_popup()

func _on_interaction_area_body_exited(body):
	print("Yang keluar area gajah: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = false
		popup_is_open = false

func show_interaction_popup():
	if popup_is_open:
		return

	if !DataGame.sapi_selesai:
		var warning_popup = WARNING_POPUP_SCENE.instantiate()
		get_tree().root.add_child(warning_popup)
		warning_popup.tampilkan_popup("Kamu harus menyelesaikan kuis sapi terlebih dahulu!")

		popup_is_open = true
		warning_popup.tree_exited.connect(_on_popup_closed)
		return
	
	var popup_scene = load(popup_scene_path)
	
	if popup_scene == null:
		print("Popup gajah tidak ditemukan. Cek path: ", popup_scene_path)
		return
	
	var popup_instance = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup_instance)
	
	popup_is_open = true
	popup_instance.tree_exited.connect(_on_popup_closed)

	print("Popup gajah muncul")

func _on_popup_closed():
	if player_inside_area:
		popup_is_open = true
	else:
		popup_is_open = false
