extends Node

var can_play: bool = true
var music: Dictionary = {}
var sfx: Dictionary = {}
var npc_sfx: Dictionary = {}

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer
@onready var npc_player: AudioStreamPlayer = $NpcPlayer

func _ready() -> void:
	music = {
		"title": load("res://audio/bgm.wav"),
		"world": load("res://audio/bgm.wav"),
		"quiz": load("res://audio/bgm.wav")
	}

	sfx = {
		"click": load("res://audio/sfx_click.wav"),
		"dialog": load("res://audio/sfx_dialog_muncul.ogg"),
		"type": load("res://audio/sfx_ketikan.ogg"),
		"correct": load("res://audio/sfx_jawaban_benar.wav"),
		"wrong": load("res://audio/sfx_jawban_salah.wav"),
		"door_open": load("res://audio/sound buka pintu.wav"),
		"door_close": load("res://audio/tutup pintu.wav")
	}

	npc_sfx = {
		"kelinci": load("res://audio/sfx_dialog_muncul.ogg"),
		"gajah": load("res://audio/Gajah.mp3"),
		"burung": load("res://audio/burung.mp3")
	}

	play_music("title")

func play_music(music_name: String = "world") -> void:
	if !can_play:
		return
	if !music.has(music_name) or music[music_name] == null:
		push_warning("Music tidak ditemukan: " + music_name)
		return

	var next_stream: AudioStream = music[music_name]
	if music_player.stream == next_stream and music_player.playing:
		return

	music_player.stream = next_stream
	music_player.play()

func stop_music() -> void:
	music_player.stop()

func play_sound(sound_name = "click") -> void:
	if !can_play:
		return

	var resolved_name: String = str(sound_name)
	if typeof(sound_name) == TYPE_INT:
		if sound_name == 0:
			resolved_name = "click"
		elif sound_name == 1:
			resolved_name = "wrong"

	if !sfx.has(resolved_name) or sfx[resolved_name] == null:
		push_warning("SFX tidak ditemukan: " + resolved_name)
		return

	sfx_player.stream = sfx[resolved_name]
	sfx_player.play()

func play_npc_sound(npc_name: String) -> bool:
	if !can_play:
		return false
	if !npc_sfx.has(npc_name) or npc_sfx[npc_name] == null:
		push_warning("Audio NPC tidak ditemukan: " + npc_name)
		return false

	npc_player.stop()
	npc_player.stream = npc_sfx[npc_name]
	npc_player.play()
	return true
