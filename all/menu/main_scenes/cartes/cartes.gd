extends ControlFocus

const CARTE = preload("res://all/cards/carte.tscn")
const MY_SCROLL = preload("res://all/menu/main_scenes/cartes/my_scroll.tscn")
const GROUP_DESCRIPTION = preload("res://all/menu/main_scenes/cartes/group_description.tscn")

var group_index : int = 0 : set = _set_group_index
# Transérer au myscroll de gérer ça, connecter input free scroll wuand on change de sceroll au scroll correspondant


# TODO: add spacing to scroll to have only 1 card at the time and 
# make the size of card fits the screen when testing


@onready var drag_preview: DragPreview = %DragPreview
@onready var input_free_scroll: FreeScroll = %InputFreeScroll

#@onready var hide_button_return: HideButton = %HideButtonReturn



func _ready() -> void:
	for i: int in Data.card_group_datas.size():
		# Add group
		var my_scroll : MyScroll = MY_SCROLL.instantiate()
		add_child(my_scroll)
		my_scroll.drag_preview = drag_preview
		
		# Group Description to add TODO
		var group_description : GroupDescription = GROUP_DESCRIPTION.instantiate()
		my_scroll.cards.add_child(group_description)
		group_description.card_group_data = Data.card_group_datas[i]
		
		for j: int in Data.card_group_datas[i].cards_data.size():
			var carte : Carte = CARTE.instantiate()
			my_scroll.cards.add_child(carte)
			carte.card_data = Data.card_group_datas[i].cards_data[j]
			
			my_scroll.position.y = get_window().size.y
	group_index = 0
	var my_scroll: MyScroll = get_child(group_index)
	my_scroll.card_index = 0
	
	my_scroll.position.y = 0
	input_free_scroll.my_scroll = my_scroll
	#input_free_scroll.index_changed.connect( my_scroll._on_input_free_scroll_index_changed )
	
	InputHelper.input_down_emitted.connect( _on_input_down_emitted )
	InputHelper.input_tap_released_emitted.connect( _on_input_tap_released_emitted )
	InputHelper.input_up_emitted.connect( _on_input_up_emitted )
	#InputHelper.input_left_emitted.connect( _on_input_left_emitted )
	#InputHelper.input_right_emitted.connect( _on_input_right_emitted )


func focus(_time_scale : float = 1.0) -> void:
	super(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	super(_time_scale)


func move_to(_index_to_add: int) -> void:
	var my_scroll_last: MyScroll = get_child(group_index)
	
	var index: int = group_index + _index_to_add
	if index >= get_child_count() : return
	if index < 0 : return
	group_index = index
	var my_scroll_target: MyScroll = get_child(group_index)
	
	var last_pos : float = get_window().size.y * -signf(_index_to_add)

	my_scroll_last.move_to( last_pos )
	my_scroll_target.move_to( 0.0 )


func go_to(_index_to_add : int) -> void:
	var my_scroll : MyScroll = get_child(group_index)
	my_scroll.go_to(_index_to_add)


func _on_input_left_emitted() -> void:
	go_to(-1)

func _on_input_right_emitted() -> void:
	go_to(+1)


func _on_input_tap_released_emitted(event : InputEvent) -> void:
	var my_scroll: MyScroll = get_child(group_index)
	my_scroll.tap()


func _on_input_up_emitted() -> void:
	move_to(-1)

func _on_input_down_emitted() -> void:
	move_to(+1)


func _set_group_index(_group_index: int) -> void:
	var old_my_scroll: MyScroll = get_child(group_index)
	if input_free_scroll.index_changed.is_connected( old_my_scroll._on_input_free_scroll_index_changed ):
		input_free_scroll.index_changed.disconnect( old_my_scroll._on_input_free_scroll_index_changed )
	
	group_index = clampi(_group_index, 0, get_child_count() - 1)
	
	var my_scroll: MyScroll = get_child(group_index)
	input_free_scroll.my_scroll = my_scroll
	
	input_free_scroll.index_changed.connect( my_scroll._on_input_free_scroll_index_changed )
	
	var no_top := not group_index == 0
	drag_preview.change_side_state(Side.SideType.TOP, no_top)
	var no_bot := not group_index == get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.BOT, no_bot)
