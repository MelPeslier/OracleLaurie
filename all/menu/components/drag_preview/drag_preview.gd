class_name DragPreview
extends Control


@onready var top: Side = $Top
@onready var right: Side = $Right
@onready var bot: Side = $Bot
@onready var left: Side = $Left


func change_side_state(_side_type : Side.SideType, _is_available: bool) -> void:
	match _side_type:
		Side.SideType.LEFT:
			left.is_available = _is_available
		Side.SideType.RIGHT:
			right.is_available = _is_available
		Side.SideType.TOP:
			top.is_available = _is_available
		Side.SideType.BOT:
			bot.is_available = _is_available
