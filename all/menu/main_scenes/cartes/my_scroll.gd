class_name MyScroll
extends ScrollContainer


@export var up_scroll_tween_data : TweenData
var up_scroll_tween : Tween

@export var scroll_tween_data : TweenData
var scroll_tween : Tween


# WARNING index = 0 is card group
var card_index : int = 0 : set = _set_card_index
@export var drag_preview: DragPreview = null


@onready var cards: HBoxContainer = %Cards

var selected := false

func _ready() -> void:
	go_to(0)


func _on_input_free_scroll_index_changed(_new_index: int) -> void:
	card_index = _new_index


func move_to(_target_pos: float, _selected : bool = true) -> void:
	if up_scroll_tween and up_scroll_tween.is_running():
		up_scroll_tween.kill()
	up_scroll_tween = create_tween().set_parallel()
	up_scroll_tween_data.set_data(up_scroll_tween)
	up_scroll_tween.tween_property(self, "position:y", _target_pos, up_scroll_tween_data.duration)
	
	selected = _selected
	if not _selected: 
		var old_child: Control = cards.get_child(card_index)
		if old_child is TirageGroupe:
			old_child.deactivate()
		return
	#go_to(0)



func go_to(_index_to_add : int) -> void:
	var index: int = card_index + _index_to_add
	print("card_index  my scroll : ", card_index)
	if index >= cards.get_child_count() : return
	if index < 0 : return
	
	var old_child: Control = cards.get_child(index)
	if old_child is TirageGroupe:
		old_child.deactivate()
	
	card_index = index
	var target_child : Control = cards.get_child(index)
	var target_pos : float = target_child.position.x

	if scroll_tween and scroll_tween.is_running():
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween_data.set_data(scroll_tween)
	scroll_tween.tween_property(self, "scroll_horizontal", target_pos, scroll_tween_data.duration)
	
	if target_child is TirageGroupe:
		target_child.activate()


func tap() -> void:
	var obj = cards.get_child(card_index)
	if obj is Carte:
		var carte: Carte = obj
		carte.tap()
	elif obj is GroupDescription:
		var group_description: GroupDescription = obj
		group_description.tap()
	elif obj is TirageGroupe:
		var tirage_groupe : TirageGroupe = obj
		tirage_groupe.tap()


func _set_card_index(_index: int) -> void:
	card_index = clampi(_index, 0, cards.get_child_count() - 1)
	print(name, " card index : ", card_index)
	var no_left := not card_index == 0
	drag_preview.change_side_state(Side.SideType.LEFT, no_left)
	var no_right := not card_index == cards.get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.RIGHT, no_right)
