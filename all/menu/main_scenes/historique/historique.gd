extends ControlFocus

const TIRAGE_BOX = preload("res://all/menu/main_scenes/historique/tirage_box.tscn")

@export var td: TweenData

var tween: Tween

@onready var v_box: VBoxContainer = %VBox
@onready var no_tirage: Label = %NoTirage


func _ready() -> void:
	if Data.save_manager.tirage_saves.is_empty():
		if tween and tween.is_running():
			tween.kill()
		tween = create_tween()
		td.set_data( tween )
		tween.tween_property(no_tirage, "modulate:a", 1.0, td.duration)
		return
	
	for tirage_save: TirageSave in Data.save_manager.tirage_saves:
		var tirage_box : TirageBox = TIRAGE_BOX.instantiate()
		v_box.add_child( tirage_box )
		tirage_box.tirage_save = tirage_save
		# Invert order
		v_box.move_child(tirage_box, 0)
		
	add_dummy(true)
	add_dummy()


func add_dummy(_at_start := false) -> void:
	var dummy := Control.new()
	dummy.custom_minimum_size.y = 60
	v_box.add_child( dummy )
	if _at_start:
		v_box.move_child( dummy, 0 ) 
	
