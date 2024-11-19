extends CanvasLayer

const DEFAULT_TRANSITION_SCREEN : PackedScene = preload("res://all/menu/components/helper/transition_screen/default_transition_screen.tscn")


var in_transition : bool = false


func change_scene_to_packed(_packed_scene: PackedScene, _transition_screen_packed : PackedScene = null) -> void:
	_change_scene("", _packed_scene, _transition_screen_packed)


func change_scene_to_file(_scene_path: String, _transition_screen_packed : PackedScene = null) -> void:
	_change_scene(_scene_path, null, _transition_screen_packed)


func _change_scene(_scene_path: String = "", _packed_scene: PackedScene = null, _transition_screen_packed : PackedScene = null) -> void:
	if in_transition: 
		push_warning("in transition")
		return
	
	var transition_screen := _instantiate_transition_screen(_transition_screen_packed)
	add_child(transition_screen)
	transition_screen.appear()
	await transition_screen.appeared
	
	if _packed_scene:
		var err = get_tree().change_scene_to_packed( _packed_scene )
		if err:
			push_error("packed : failed to change scenes: %d" % err)
			get_tree().quit()
	elif not _scene_path == "":
		var err = get_tree().change_scene_to_file( _scene_path )
		if err:
			push_error("path : failed to change scenes: %d" % err)
			get_tree().quit()
	else:
		push_error("ScneTransition.gd : no packedscene nor scene path passed")
	
	transition_screen.disappear()
	await transition_screen.disappeared
	transition_screen.queue_free()


func _instantiate_transition_screen(_transition_screen_packed: PackedScene) -> TransitionScreen:
	if not _transition_screen_packed:
		_transition_screen_packed = DEFAULT_TRANSITION_SCREEN
	var transition_screen = _transition_screen_packed.instantiate() as TransitionScreen
	if not transition_screen is TransitionScreen:
		push_warning("SceneTransition has been passed the wrong file type")
		transition_screen = null
	return transition_screen
