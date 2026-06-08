extends Control

@onready var label_pesan = $Label_Pesan

func tampilkan_popup(teks):
	label_pesan.text = teks
	show()

func _on_button_ok_pressed():
	queue_free()
