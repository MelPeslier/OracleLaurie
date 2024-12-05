extends Control

const TIRAGE_GROUPE = preload("res://all/menu/main_scenes/tirage/tirage_groupe.tscn")

var group_index : int = 0 : set = _set_group_index

@onready var drag_preview: DragPreview = %DragPreview
@onready var scroll_cards: MyScroll = $ScrollCards
@onready var scroll_ideas: MyScroll = $ScrollIdeas


func _ready() -> void:
	for card_group_data : CardGroupData in Data.card_group_datas:
		var tirage : TirageGroupe = TIRAGE_GROUPE.instantiate()
		scroll_cards.get_child(0).add_child( tirage )
		tirage.card_group_data = card_group_data


func move_to(_index_to_add: int) -> void:
	var my_scroll_last: MyScroll = get_child(group_index)
	
	var index: int = group_index + _index_to_add
	if index >= get_child_count() : return
	if index < 0 : return
	group_index = index
	print(group_index)
	var my_scroll_target: MyScroll = get_child(group_index)
	
	var last_pos : float = get_window().size.y * -signf(_index_to_add)

	my_scroll_last.move_to( last_pos )
	my_scroll_target.move_to( 0.0 )


func go_to(_index_to_add : int) -> void:
	var my_scroll : MyScroll = get_child(group_index)
	my_scroll.go_to(_index_to_add)


func _on_input_left_emitted() -> void:
	#print("left_emitted")
	if InputHelper.is_mobile():
		#print("left canceled")
		return
	go_to(-1)

func _on_input_right_emitted() -> void:
	#print("right_emitted")
	if  InputHelper.is_mobile():
		#print("right canceled")
		return
	go_to(+1)


func _on_input_tap_emitted() -> void:
	var my_scroll: MyScroll = get_child(group_index)
	my_scroll.tap()


func _on_input_up_emitted() -> void:
	move_to(-1)

func _on_input_down_emitted() -> void:
	move_to(+1)


func _set_group_index(_group_index: int) -> void:
	group_index = clampi(_group_index, 0, get_child_count() - 1)
	
	var my_scroll: MyScroll = get_child(group_index)
	
	var no_top := not group_index == 0
	drag_preview.change_side_state(Side.SideType.TOP, no_top)
	var no_bot := not group_index == get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.BOT, no_bot)
