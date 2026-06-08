extends Node2D

var questions: Array[Dictionary] = [
	{
		"question": "1. Kata kelinci dieja menjadi...",
		"answers": ["A. k-e-l-i-n-c-i", "B. k-e-n-l-i-c-i", "C. k-l-e-i-n-c-i"],
		"correct": 0
	},
	{
		"question": "2. Kata telinga dieja menjadi...",
		"answers": ["A. t-e-l-i-n-g-a", "B. t-e-g-l-i-n-a", "C. t-i-l-e-n-g-a"],
		"correct": 0
	},
	{
		"question": "3. Kelinci melompat menggunakan...",
		"answers": ["A. Kaki belakang", "B. Sayap", "C. Sirip"],
		"correct": 0
	}
]

var current_question_index: int = 0
var score: int = 0
var wrong_attempts: int = 0
var can_answer: bool = true

@onready var material_text: RichTextLabel = $UI/MaterialPanel/MaterialContentBox/MaterialText
@onready var quiz_panel: Control = $UI/MaterialPanel/MaterialContentBox/QuizPanel

@onready var question_label: Label = $UI/MaterialPanel/MaterialContentBox/QuizPanel/QuestionLabel

@onready var button_a: TextureButton = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonA
@onready var button_b: TextureButton = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonB
@onready var button_c: TextureButton = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonC

@onready var label_a: Label = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonA/LabelA
@onready var label_b: Label = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonB/LabelB
@onready var label_c: Label = $UI/MaterialPanel/MaterialContentBox/QuizPanel/ButtonC/LabelC

@onready var result_text: RichTextLabel = $UI/MaterialPanel/MaterialContentBox/ResultText

@onready var star_container: Control = $UI/MaterialPanel/MaterialContentBox/StarContainer
@onready var star_1: TextureRect = $UI/MaterialPanel/MaterialContentBox/StarContainer/Star1
@onready var star_2: TextureRect = $UI/MaterialPanel/MaterialContentBox/StarContainer/Star2
@onready var star_3: TextureRect = $UI/MaterialPanel/MaterialContentBox/StarContainer/Star3

@onready var back_button: TextureButton = $UI/MaterialPanel/BackButton
@onready var start_quiz_button: TextureButton = $UI/MaterialPanel/StartQuizButton
@onready var finish_button: TextureButton = $UI/MaterialPanel/FinishButton
@onready var retry_button: TextureButton = $UI/MaterialPanel/RetryButton


func _ready() -> void:
	start_quiz_button.pressed.connect(_on_start_quiz_button_pressed)
	back_button.pressed.connect(_on_back_button_pressed)
	finish_button.pressed.connect(_on_finish_button_pressed)
	retry_button.pressed.connect(_on_retry_button_pressed)

	button_a.pressed.connect(func(): answer_question(0))
	button_b.pressed.connect(func(): answer_question(1))
	button_c.pressed.connect(func(): answer_question(2))

	show_material_state()


func show_material_state() -> void:
	current_question_index = 0
	score = 0
	wrong_attempts = 0
	can_answer = true

	material_text.visible = true
	quiz_panel.visible = false
	result_text.visible = false
	star_container.visible = false

	back_button.visible = true
	start_quiz_button.visible = true
	finish_button.visible = false
	retry_button.visible = false

	material_text.bbcode_enabled = true
	material_text.text = "Kelinci adalah hewan kecil yang lucu. Kata kelinci dieja k-e-l-i-n-c-i. Kelinci mempunyai telinga yang panjang. Kata telinga dieja t-e-l-i-n-g-a. Kelinci suka makan wortel dan rumput. Kelinci melompat menggunakan kaki belakangnya yang kuat."


func _on_start_quiz_button_pressed() -> void:
	start_quiz()


func start_quiz() -> void:
	current_question_index = 0
	score = 0
	wrong_attempts = 0
	can_answer = true

	material_text.visible = false
	quiz_panel.visible = true
	result_text.visible = false
	star_container.visible = false

	back_button.visible = false
	start_quiz_button.visible = false
	finish_button.visible = false
	retry_button.visible = false

	show_question()


func show_question() -> void:
	can_answer = true

	var question_data: Dictionary = questions[current_question_index]

	question_label.text = question_data["question"]
	label_a.text = question_data["answers"][0]
	label_b.text = question_data["answers"][1]
	label_c.text = question_data["answers"][2]

	button_a.visible = true
	button_b.visible = true
	button_c.visible = true

	button_a.disabled = false
	button_b.disabled = false
	button_c.disabled = false


func answer_question(selected_index: int) -> void:
	if can_answer == false:
		return

	can_answer = false

	var question_data: Dictionary = questions[current_question_index]
	var correct_index: int = question_data["correct"]

	button_a.disabled = true
	button_b.disabled = true
	button_c.disabled = true

	if selected_index == correct_index:
		score += 1
		print("Jawaban benar")
	else:
		wrong_attempts += 1
		print("Jawaban salah")

	await get_tree().create_timer(0.8).timeout

	current_question_index += 1

	if current_question_index < questions.size():
		show_question()
	else:
		show_quiz_finished()


func show_quiz_finished() -> void:
	print("Kuis kelinci selesai. Skor: ", score, " dari ", questions.size())

	material_text.visible = false
	quiz_panel.visible = false
	result_text.visible = true
	star_container.visible = true

	back_button.visible = false
	start_quiz_button.visible = false

	if score == questions.size():
		finish_button.visible = true
		retry_button.visible = false
	else:
		finish_button.visible = false
		retry_button.visible = true

	show_stars()
	show_result_text()


func show_stars() -> void:
	star_1.visible = false
	star_2.visible = false
	star_3.visible = false

	if score >= 3:
		star_1.visible = true
		star_2.visible = true
		star_3.visible = true
	elif score == 2:
		star_1.visible = true
		star_2.visible = true
	else:
		star_1.visible = true


func show_result_text() -> void:
	var title_result := ""
	var message := ""
	var hint_text := ""

	if score == questions.size():
		title_result = "Hebat!"
		message = "Kamu menyelesaikan level kelinci dengan sempurna!"
		hint_text = "Level kelinci selesai.\nKlik selesai untuk kembali ke map."
	elif score == 2:
		title_result = "Bagus!"
		message = "Kamu hampir menguasai materi kelinci."
		hint_text = "Ulangi kuis untuk mendapatkan\nhasil yang lebih baik."
	else:
		title_result = "Tetap Semangat!"
		message = "Baca lagi materinya dan coba pahami kembali."
		hint_text = "Ulangi kuis untuk memperbaiki skor."

	result_text.bbcode_enabled = true
	result_text.text = "[center]" \
		+ "[color=#FFD84D][font_size=12]" + title_result + "[/font_size][/color]\n\n" \
		+ "[font_size=10]" \
		+ "Skor Benar: [color=#55FF55]" + str(score) + "/" + str(questions.size()) + "[/color]\n" \
		+ "Jumlah Salah: [color=#FF6B5A]" + str(wrong_attempts) + "[/color]\n\n" \
		+ message + "\n\n" \
		+ hint_text \
		+ "[/font_size]" \
		+ "[/center]"


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_finish_button_pressed() -> void:
	DataGame.kelinci_selesai = true
	get_tree().change_scene_to_file("res://world/world.tscn")


func _on_retry_button_pressed() -> void:
	show_material_state()
