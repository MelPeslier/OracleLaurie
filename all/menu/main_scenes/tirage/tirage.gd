extends Control

const TIRAGE_GROUPE = preload("res://all/menu/main_scenes/tirage/tirage_groupe.tscn")
const MIND_TEXT = preload("res://all/menu/components/mind_text/mind_text.tscn")
const CARTE = preload("res://all/cards/carte.tscn")

var group_index : int = 0 : set = _set_group_index
var can_move := false

@onready var drag_preview: DragPreview = %DragPreview
@onready var scroll_cards: MyScroll = $ScrollCards
@onready var scroll_ideas: MyScroll = $ScrollIdeas
@onready var mind_texts: VBoxContainer = %MindTexts


func _ready() -> void:
	InputHelper.input_left_emitted.connect( _on_input_left_emitted )
	InputHelper.input_right_emitted.connect( _on_input_right_emitted )
	InputHelper.input_tap_released_emitted.connect( _on_input_tap_release_emitted )
	InputHelper.input_up_emitted.connect( _on_input_up_emitted )
	InputHelper.input_down_emitted.connect( _on_input_down_emitted )
	
	scroll_ideas.position.y = get_window().size.y

	# Affiche a draw
	if Data.tirage_actuel:
		can_move = true
		for card_ref in Data.tirage_actuel.cards_ref:
			var carte : Carte = CARTE.instantiate()
			scroll_cards.cards.add_child( carte )
			carte.card_data = Data.get_card_data_from_card_ref( card_ref )
		
		var last_mind_save : MindText
		for mind_save : MindSave in Data.tirage_actuel.minds_save:
			var mind_text : MindText = MIND_TEXT.instantiate()
			mind_text.mind_save = mind_save
			mind_texts.add_child( mind_text )
			mind_texts.move_child(mind_text, 0)
			last_mind_save = mind_text
			# TODO : false only if date is too long ago
		
		if not last_mind_save.is_today():
			var mind_text : MindText = MIND_TEXT.instantiate()
			mind_texts.add_child( mind_text )
			mind_texts.move_child(mind_text, 0)
		
		group_index = 0
		var my_scroll: MyScroll = get_child(group_index)
		my_scroll.card_index = 0
		my_scroll.move_to(0.0)
		return
	
	# Else do a draw
	Data.tirage_actuel = TirageSave.new()
	for card_group_data : CardGroupData in Data.card_group_datas:
		var tirage : TirageGroupe = TIRAGE_GROUPE.instantiate()
		scroll_cards.cards.add_child( tirage )
		tirage.card_group_data = card_group_data
		if card_group_data.titre == "KARMA":
			tirage.card_choosen.connect( _on_first_card_choosen )
	
	var mind_text : MindText = MIND_TEXT.instantiate()
	mind_texts.add_child( mind_text )
	
	group_index = 0
	var my_scroll: MyScroll = get_child(group_index)
	my_scroll.card_index = 0
	my_scroll.move_to(0.0)


func _on_first_card_choosen() -> void:
	Data.save_manager.tirage_saves.append( Data.tirage_actuel )
	can_move = true


func move_to(_index_to_add: int) -> void:
	if not can_move : return
	var my_scroll_last: MyScroll = get_child(group_index)
	
	var index: int = group_index + _index_to_add
	if index >= get_child_count() : return
	if index < 0 : return
	group_index = index
	var my_scroll_target: MyScroll = get_child(group_index)
	
	var last_pos : float = get_window().size.y * -signf(_index_to_add)

	my_scroll_last.move_to( last_pos, false )
	my_scroll_target.move_to( 0.0 )


func go_to(_index_to_add : int) -> void:
	if not can_move : return
	var my_scroll : MyScroll = get_child(group_index)
	my_scroll.go_to(_index_to_add)


func _on_input_left_emitted() -> void:
	go_to(-1)

func _on_input_right_emitted() -> void:
	go_to(+1)


func _on_input_tap_release_emitted(_event: InputEvent) -> void:
	var my_scroll: MyScroll = get_child(group_index)
	my_scroll.tap()


func _on_input_up_emitted() -> void:
	move_to(-1)

func _on_input_down_emitted() -> void:
	move_to(+1)


func _set_group_index(_group_index: int) -> void:
	var old_my_scroll: MyScroll = get_child(group_index)
	
	group_index = clampi(_group_index, 0, get_child_count() - 1)
	
	var my_scroll: MyScroll = get_child(group_index)
	
	var no_top := not group_index == 0
	drag_preview.change_side_state(Side.SideType.TOP, no_top)
	var no_bot := not group_index == get_child_count() - 1
	drag_preview.change_side_state(Side.SideType.BOT, no_bot)


func _on_hide_button_return_clicked() -> void:
	for mind_text: MindText in mind_texts.get_children():
		mind_text._on_timer_timeout()
