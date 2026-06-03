extends CanvasLayer

@onready var start_quiz_button: TextureButton = $Panel/StartQuizButton
@onready var close_button: TextureButton = $Panel/CloseButton

func _ready():
	print("CowInteractionPopup berhasil muncul")
	
	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_start_quiz_button_pressed():
	print("Tombol Mulai ditekan")
	get_tree().change_scene_to_file("res://popup games/cow_quiz.tscn")

func _on_close_button_pressed():
	print("Tombol Kembali ditekan")
	queue_free()
