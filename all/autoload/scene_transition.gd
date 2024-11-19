extends CanvasLayer

const DEFAULT_TRANSITION_SCREEN : PackedScene = preload("res://all/menu/components/helper/transition_screen/default_transition_screen.tscn")


var in_transition : bool = false


func change_scene_to_packed(_packed_scene: PackedScene, _transition_screen_packed : PackedScene = null) -> void:
	if in_transition: 
		push_warning("in transition")
		return
	
	var transition_screen := instantiate_transition_screen(_transition_screen_packed)
	add_child(transition_screen)
	transition_screen.appear()
	await transition_screen.appeared
	
	print(_packed_scene)
	
	var err = get_tree().change_scene_to_packed(_packed_scene)
	if err:
		push_error("failed to change scenes: %d" % err)
		get_tree().quit()
	
	transition_screen.disappear()
	await transition_screen.disappeared
	transition_screen.queue_free()


func instantiate_transition_screen(_transition_screen_packed: PackedScene) -> TransitionScreen:
	if not _transition_screen_packed:
		_transition_screen_packed = DEFAULT_TRANSITION_SCREEN
	var transition_screen = _transition_screen_packed.instantiate() as TransitionScreen
	if not transition_screen is TransitionScreen:
		push_warning("SceneTransition has been passed the wrong file type")
		transition_screen = null
	return transition_screen
