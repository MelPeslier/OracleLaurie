extends Node

signal color_changed(_color_helper: ColorHelper)


const CardGenerator = preload("res://all/cards/resources/card_generator.gd")


var card_group_datas : Array[CardGroupData]


var color_tween : Tween


@onready var color_helper := ColorHelper.new()


func color_trans(_new: ColorHelper, _td: TweenData = TweenData.new()) -> void:
	set_physics_process(true)
	if color_tween and color_tween.is_running():
		color_tween.kill()
	color_tween = create_tween().set_parallel()
	_td.set_data(color_tween)
	color_tween.tween_property(color_helper, "background_color", _new.background_color, _td.duration)
	color_tween.tween_property(color_helper, "main_color", _new.main_color, _td.duration)
	color_tween.tween_property(color_helper, "second_color", _new.second_color, _td.duration)
	color_tween.tween_property(color_helper, "third_color", _new.third_color, _td.duration)
	color_tween.chain().tween_callback( set_physics_process.bind(false) )


## Return the card data related to the card ref asked if exist
func get_card_data_from_card_ref( _card_ref: CardRef ) -> CardData:
	for card_group_data : CardGroupData in card_group_datas:
		if card_group_data.titre == _card_ref.group_titre:
			for card_data : CardData in card_group_data.cards_data:
				if card_data.card_id == _card_ref.card_id:
					return card_data
	return null
