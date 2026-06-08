extends CanvasLayer

@onready var start_quiz_button: TextureButton = $Panel/StartQuizButton
@onready var close_button: TextureButton = $Panel/CloseButton
@onready var label: Label = $Panel/Label

func _ready():
	print("CowInteractionPopup berhasil muncul")

	label.text = "Mau menjawab kuis tentang sapi?"

	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)

func _on_start_quiz_button_pressed():
	if !DataGame.kelinci_selesai:
		print("POPUP SAPI DIHAPUS")

		queue_free()

		var popup = preload("res://popup peringatan/ui_peringatan.tscn").instantiate()
		get_tree().root.add_child(popup)

		return

func _on_close_button_pressed():
	print("Tombol Kembali Cow ditekan")
	queue_free()
