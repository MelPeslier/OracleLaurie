class_name TweenData
extends Resource

@export var ease_type : Tween.EaseType
@export var trans_type : Tween.TransitionType
@export_range(0.0, 3.0, 0.001, "or_greater", "suffix:s") var duration : float = 1.0

func set_data(_tween: Tween) -> void:
	_tween.set_ease(ease_type)
	_tween.set_trans(trans_type)

func kill_and_create(_node: Node, _tween: Tween, _parallel: bool = false) -> float:
	if _tween and _tween.is_running():
		_tween.kill()
	_tween = _node.create_tween().set_parallel(_parallel)
	set_data(_tween)
	return duration
