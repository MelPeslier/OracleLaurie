class_name MindText
extends Control


var mind_save : MindSave
var saved := false


@onready var text_edit: TextEdit = %TextEdit
@onready var timer: Timer = %Timer


func _ready() -> void:
	if not mind_save:
		mind_save = MindSave.new()
		Data.tirage_actuel.minds_save.append( mind_save )


func _on_text_edit_text_changed() -> void:
	timer.start()
	saved = false


func _on_timer_timeout() -> void:
	var self_pos : int = Data.tirage_actuel.minds_save.find( self )
	#mind_save.text = 
	Data.save_manager.save()
	saved = true
