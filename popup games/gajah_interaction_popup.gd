extends CanvasLayer

@onready var start_quiz_button: TextureButton = $Panel/StartQuizButton
@onready var close_button: TextureButton = $Panel/CloseButton
@onready var label: Label = $Panel/Label

func _ready():
	print("ElephantInteractionPopup berhasil muncul")

	label.text = "Mau menjawab kuis tentang gajah?"

	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_start_quiz_button_pressed():
	if !DataGame.sapi_selesai:
		queue_free()

		var popup = preload("res://popup peringatan/ui_peringatan.tscn").instantiate()
		get_tree().current_scene.add_child(popup)
		popup.tampilkan_popup("Kamu harus menyelesaikan kuis sapi terlebih dahulu!")
		return

	get_tree().change_scene_to_file("res://popup games/elephant_quiz.tscn")

func _on_close_button_pressed():
	print("Tombol Kembali Elephant ditekan")
	queue_free()
