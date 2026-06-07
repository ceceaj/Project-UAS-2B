extends CharacterBody2D

@export var wander_range: float = 5
@export var speed: int = 5
@export var popup_scene_path: String = "res://popup games/rabbit_interaction_popup.tscn"

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

	print("Script kelinci aktif")

func _physics_process(_delta):
	velocity = wanderPos * speed
	
	if randi() % 60 == 0:
		get_new_wander_dir()
	
	if move_and_slide():
		wanderPos = Vector2(-wanderPos.x, -wanderPos.y)
	
	if wanderPos.x < 0:
		sprite_2d.set_flip_h(true)
		if animation_player.has_animation("rabbit"):
			animation_player.play("rabbit")
		elif animation_player.has_animation("walk"):
			animation_player.play("walk")
	elif wanderPos.x > 0:
		sprite_2d.set_flip_h(false)
		if animation_player.has_animation("rabbit"):
			animation_player.play("rabbit")
		elif animation_player.has_animation("walk"):
			animation_player.play("walk")
	
	if randi() % 600 == 0:
		if audio_stream_player_2d != null:
			audio_stream_player_2d.play()

func get_new_wander_dir():
	var target_vector = Vector2(
		randf_range(-wander_range, wander_range),
		randf_range(-wander_range, wander_range)
	)
	wanderPos = target_vector

func _on_interaction_area_body_entered(body):
	print("Yang masuk area kelinci: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = true
		show_interaction_popup()

func _on_interaction_area_body_exited(body):
	print("Yang keluar area kelinci: ", body.name)
	
	if body.name == "PlayerCharacter":
		player_inside_area = false
		popup_is_open = false

func show_interaction_popup():
	if popup_is_open:
		return
	
	var popup_scene = load(popup_scene_path)
	
	if popup_scene == null:
		print("Popup kelinci tidak ditemukan. Cek path: ", popup_scene_path)
		return
	
	var popup_instance = popup_scene.instantiate()
	get_tree().current_scene.add_child(popup_instance)
	
	popup_is_open = true
	popup_instance.tree_exited.connect(_on_popup_closed)

	print("Popup kelinci muncul")

func _on_popup_closed():
	if player_inside_area:
		popup_is_open = true
	else:
		popup_is_open = false
