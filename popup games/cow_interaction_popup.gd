extends CanvasLayer

@onready var start_quiz_button: TextureButton = $Panel/StartQuizButton
@onready var close_button: TextureButton = $Panel/CloseButton
@onready var label: Label = $Panel/Label

func _ready():
	SoundHandler.play_sound("dialog")
	print("CowInteractionPopup berhasil muncul")

	label.text = "Mau menjawab kuis tentang sapi?"

	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_start_quiz_button_pressed():
	print("Tombol Mulai Cow ditekan")
	get_tree().change_scene_to_file("res://popup games/cow_quiz.tscn")

func _on_close_button_pressed():
	print("Tombol Kembali Cow ditekan")
	queue_free()
