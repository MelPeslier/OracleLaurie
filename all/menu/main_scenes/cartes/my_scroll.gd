class_name MyScroll
extends ScrollContainer


@export var up_scroll_tween_data : TweenData
var up_scroll_tween : Tween

@export var scroll_tween_data : TweenData
var scroll_tween : Tween


# WARNING index = 0 is card group
var card_index : int = 0 : set = _set_card_index
var drag_preview: DragPreview = null


@onready var cards: HBoxContainer = %Cards


func _on_input_free_scroll_index_changed(_new_index: int) -> void:
	card_index = _new_index


func move_to(_target_pos: float) -> void:
	if up_scroll_tween and up_scroll_tween.is_running():
		up_scroll_tween.kill()
	up_scroll_tween = create_tween().set_parallel()
	up_scroll_tween_data.set_data(up_scroll_tween)
	up_scroll_tween.tween_property(self, "position:y", _target_pos, up_scroll_tween_data.duration)



func go_to(_index_to_add : int) -> void:
	var index: int = card_index + _index_to_add
	if index >= cards.get_child_count() : return
	if index < 0 : return
	card_index = index
	var target_pos : float = cards.get_child(index).position.x

	if scroll_tween and scroll_tween.is_running():
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween_data.set_data(scroll_tween)
	scroll_tween.tween_property(self, "scroll_horizontal", target_pos, scroll_tween_data.duration)


func tap() -> void:
	var obj = cards.get_child(card_index)
	if obj is Carte:
		var carte: Carte = obj
		carte.tap()
	elif obj is GroupDescription:
		var group_description: GroupDescription = obj
		group_description.tap()


func _set_card_index(_index: int) -> void:
	card_index = clampi(_index, 0, cards.get_child_count() - 1)
	var no_left := not card_index == 0
	drag_preview.change_side_state(Side.SideType.LEFT, no_left)
	var no_right := not card_index == cards.get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.RIGHT, no_right)
