extends CanvasLayer

var target_scene = "res://world/world.tscn"

func _ready() -> void:
	var tombol = $"Panel Pop Up/tombol selesai"
	if not tombol.pressed.is_connected(_on_tombol_selesai_pressed):
		tombol.pressed.connect(_on_tombol_selesai_pressed)
	
	# TRICK: Mulai cicil loading map utama di background sejak pop-up ini PERTAMA KALI MUNCUL
	ResourceLoader.load_threaded_request(target_scene)

func _on_tombol_selesai_pressed() -> void:
	var tombol = $"Panel Pop Up/tombol selesai"
	
	# Matikan tombol agar tidak bisa di-spam klik saat proses pindah
	tombol.disabled = true
	
	# Efek membal pas diklik
	tombol.pivot_offset = tombol.size / 2
	var tween = create_tween()
	tween.tween_property(tombol, "scale", Vector2(0.8, 0.8), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(tombol, "scale", Vector2(1.0, 1.0), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	# Ambil map utama yang sudah dicicil loading-nya di background tadi
	var packed_scene = ResourceLoader.load_threaded_get(target_scene)
	
	if packed_scene:
		# Langsung pindah scene secara instan tanpa lag!
		get_tree().change_scene_to_packed(packed_scene)
	else:
		# Jaga-jaga kalau background loading belum siap, pakai cara biasa
		get_tree().change_scene_to_file(target_scene)
