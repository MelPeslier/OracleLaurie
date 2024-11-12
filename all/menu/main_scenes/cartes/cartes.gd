extends ControlFocus

const CARTE = preload("res://all/cards/carte.tscn")

var card_index : int = 0 : set = _set_card_index

var scroll_tween : Tween
var scroll_tween_data : TweenData

@onready var drag_preview: DragPreview = %DragPreview
@onready var scroll: ScrollContainer = %Scroll
@onready var cards: HBoxContainer = %Cards

# Taille de chaque intervalle de snapping en pixels
var snap_interval :float = 300


func _ready() -> void:
	var all_cards_data :Array[CardData] = []
	for i: int in Data.card_group_datas.size():
		all_cards_data.append_array( Data.card_group_datas[i].cards_data )
	
	for i: int in all_cards_data.size():
		var carte : Carte = CARTE.instantiate()
		cards.add_child(carte)
		carte.card_data = all_cards_data[i]


func _input(event: InputEvent) -> void:
	pass
	
	#if not InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN:
	
	# Keyboard & controller
	#elif InputHelper.is_action_just_released("right"):
	#elif InputHelper.is_action_just_released("left"):
	#elif InputHelper.is_action_just_released("up"):
	#elif InputHelper.is_action_just_released("down"):


func focus(_time_scale : float = 1.0) -> void:
	super(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	super(_time_scale)


func go_to(_index_to_add : int) -> void:
	var index: int = card_index + _index_to_add
	if not index < cards.get_child_count() : return
	if not index < 0 : return
	var target_pos : float = cards.get_child(index).position + cards.separation
	scroll.scroll_horizontal = cards.get_child(index).position.x + cards.separation
	
	if scroll_tween and scroll_tween.is_running():
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween_data.set_data(scroll_tween)
	scroll_tween.tween_property(scroll, "scroll_horizontal", target_pos, scroll_tween_data.duration)


func _on_input_left_emitted() -> void:
	print("left_emitted")
	if InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN:
		print("left return")
		return
	go_to(-1)


func _on_input_right_emitted() -> void:
	print("right_emitted")
	if InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN:
		print("right return")
		return
	go_to(+1)

func _on_input_tap_emitted() -> void:
	var carte: Carte = cards.get_child(card_index)
	carte.tap()


func _on_input_free_scroll_index_changed(_new_index: int) -> void:
	card_index = _new_index


func _set_card_index(_index: int) -> void:
	card_index = clampi(_index, 0, cards.get_child_count() - 1)
	var no_left := not card_index == 0
	drag_preview.change_side_state(Side.SideType.LEFT, no_left)
	var no_right := not card_index == cards.get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.RIGHT, no_right)
