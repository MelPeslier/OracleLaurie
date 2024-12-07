class_name TirageBox
extends Control

const DEBUT_DESCRIPTION_LENGTH : int = 100
const PREVIEW = preload("res://all/menu/components/mind_text/preview.tscn")

@export var td_focus: TweenData
@export var td_unfocus: TweenData
@export var focused_scale := Vector2( 1.2, 1.2 )

var tween: Tween

var tirage_save : TirageSave : set = _set_tirage_save


@onready var date: Label = %Date
@onready var debut_descripiton: Label = %DebutDescripiton
@onready var cards: HBoxContainer = %Cards
@onready var base_custom_button: BaseCustomButton = %BaseCustomButton


func _set_tirage_save(_tirage_save: TirageSave) -> void:
	tirage_save = _tirage_save
	date.text = tirage_save.date
	if not tirage_save.minds_save.is_empty():
		debut_descripiton.text = tirage_save.minds_save[0].text.substr(0, DEBUT_DESCRIPTION_LENGTH).strip_escapes()
		debut_descripiton.text
	for card_ref : CardRef in tirage_save.cards_ref:
		var preview : Preview = PREVIEW.instantiate()
		var card_data: CardData = Data.get_card_data_from_card_ref( card_ref )
		cards.add_child( preview )
		preview.texture = card_data.image


func _on_base_custom_button_focused() -> void:
	Data.tirage_actuel = tirage_save
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	td_focus.set_data( tween )
	var duration : float = td_focus.duration
	tween.tween_property(self, "scale", focused_scale, duration)


func _on_base_custom_button_unfocused() -> void:
	Data.tirage_actuel = null
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	td_unfocus.set_data( tween )
	var duration : float = td_unfocus.duration
	tween.tween_property(self, "scale", Vector2.ONE, duration)
