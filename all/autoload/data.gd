extends Node

var card_group_datas : Array[CardGroupData]

@onready var color_helper := ColorHelper.new()

var t : Tween


func color_trans(_new: ColorHelper, _td: TweenData = TweenData.new()) -> void:
	if t and t.is_running():
		t.kill()
	t = create_tween().set_parallel()
	_td.set_data(t)
	
