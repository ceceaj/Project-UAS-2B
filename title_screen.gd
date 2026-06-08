extends Node

#Variables to control what is displaying on the screen
@onready var main_menu_container = %MainMenuContainer
@onready var options_container = %OptionsContainer
@onready var credits_container = %CreditsContainer
@onready var bg_pan = $AnimationPlayer
@onready var intro_layer: Control = %IntroLayer
@onready var intro_video: VideoStreamPlayer = %IntroVideo
@onready var intro_fade: ColorRect = %IntroFade


signal level_changed(level_name)

@export var world_level: PackedScene = load("res://world/world.tscn")

const INTRO_FADE_DURATION := 1.0

var intro_started := false

#Sets up panning background and correct buttons displayed
func _ready():
	SoundHandler.play_music("title")
	bg_pan.play("bg_panning")
	main_menu_container.visible = true
	options_container.visible = false
	credits_container.visible = false
	intro_layer.visible = false
	intro_video.modulate.a = 1.0
	intro_fade.color = Color.BLACK
	intro_fade.color.a = 0.0

# --------- PLAY BUTTON ---------
#--------------------------------

## Switches from main menu to main scene when player presses play button
func _on_play_pressed():
	start_intro_sequence()
	#get_tree().change_scene_to_file()

func start_intro_sequence():
	if intro_started:
		return

	intro_started = true
	SoundHandler.stop_music()
	main_menu_container.visible = false
	options_container.visible = false
	credits_container.visible = false
	intro_layer.visible = true
	intro_video.play()

func _on_intro_video_finished():
	await intro_finished()

func intro_finished():
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(intro_video, "modulate:a", 0.0, INTRO_FADE_DURATION)
	tween.tween_property(intro_fade, "color:a", 1.0, INTRO_FADE_DURATION)
	await tween.finished
	emit_signal("level_changed", world_level)

# --------- OPTIONS CONTROL ---------
#------------------------------------

#Hides main menu and opens options menu when options button is pressed
func _on_options_pressed():
	main_menu_container.visible = false
	options_container.visible = true

#Hides options menu and returns view to main menu when back button is pressed
func _on_options_back_pressed():
	main_menu_container.visible = true
	options_container.visible = false

#Toggles game music on and off
func _on_music_button_toggled(button_pressed):
	if button_pressed:
		SoundHandler.can_play = false
		SoundHandler.stop_music()
	else:
		SoundHandler.can_play = true
		SoundHandler.play_music()

# --------- CREDITS BUTTON ---------
#-----------------------------------

#Displays credits when pressed
func _on_credits_pressed():
	main_menu_container.visible = false
	credits_container.visible = true

#Hides credit when pressed
func _on_credits_back_pressed():
	main_menu_container.visible = true
	credits_container.visible = false


# --------- EXIT BUTTON ---------
#--------------------------------

#Will close and exit the game when the exit button is pressed
func _on_quit_pressed():
	get_tree().quit()
