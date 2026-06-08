extends Node

@onready var current_level = $TitleScreen

const SCENE_FADE_IN_DURATION := 1.0

var transition_layer: CanvasLayer
var transition_fade: ColorRect

func _ready() -> void:
	randomize()
	_setup_transition_fade()
	current_level.level_changed.connect(switch_scene)
## Takes filepath to a Scene and replace the current level by a new one.

func switch_scene(level: PackedScene) -> void:
	var next_level = level.instantiate()
	transition_fade.color.a = 1.0
	transition_layer.visible = true
	current_level.queue_free()
	current_level = next_level
	add_child(current_level)
	move_child(transition_layer, get_child_count() - 1)
	current_level.level_changed.connect(switch_scene)
	fade_in_from_black()
	
func _setup_transition_fade() -> void:
	transition_layer = CanvasLayer.new()
	transition_layer.name = "SceneTransitionLayer"
	transition_layer.layer = 100

	transition_fade = ColorRect.new()
	transition_fade.name = "SceneTransitionFade"
	transition_fade.color = Color.BLACK
	transition_fade.color.a = 0.0
	transition_fade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_fade.set_anchors_preset(Control.PRESET_FULL_RECT)

	transition_layer.visible = false
	transition_layer.add_child(transition_fade)
	add_child(transition_layer)

func fade_in_from_black() -> void:
	var tween := create_tween()
	tween.tween_property(transition_fade, "color:a", 0.0, SCENE_FADE_IN_DURATION)
	await tween.finished
	transition_layer.visible = false
