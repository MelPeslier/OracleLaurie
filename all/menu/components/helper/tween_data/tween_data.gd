class_name TweenData
extends Resource

@export var ease_type : Tween.EaseType
@export var trans_type : Tween.TransitionType
@export_range(0.0, 3.0, 0.001, "or_greater", "suffix:s") var duration : float = 1.0

func set_data(_tween: Tween) -> void:
	_tween.set_ease(ease_type)
	_tween.set_trans(trans_type)
	
