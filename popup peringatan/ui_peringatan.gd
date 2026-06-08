extends CanvasLayer

@onready var label_pesan: Label = $Label_Pesan

func _ready() -> void:
	layer = 100
	SoundHandler.play_sound("dialog")

func tampilkan_popup(teks: String) -> void:
	label_pesan.text = teks
	visible = true

func _on_button_ok_pressed() -> void:
	queue_free()
