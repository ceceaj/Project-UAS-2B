extends CanvasLayer

@onready var start_quiz_button: TextureButton = $Panel/StartQuizButton
@onready var close_button: TextureButton = $Panel/CloseButton
@onready var label: Label = $Panel/Label

func _ready():
	print("GajahInteractionPopup berhasil muncul")

	label.text = "Mau menjawab kuis tentang gajah?"
	
	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_start_quiz_button_pressed():
	print("Tombol Mulai Gajah ditekan")
	get_tree().change_scene_to_file("res://popup games/gajah_quiz.tscn")

func _on_close_button_pressed():
	print("Tombol Kembali Gajah ditekan")
	queue_free()
