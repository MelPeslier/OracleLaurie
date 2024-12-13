class_name MindText
extends Control


var mind_save : MindSave
var saved := false


@onready var text_edit: TextEdit = %TextEdit
@onready var timer: Timer = %Timer
@onready var date: Label = %Date
@onready var label: Label = %Label


func _ready() -> void:
	if not mind_save:
		mind_save = MindSave.new()
		Data.tirage_actuel.minds_save.append( mind_save )

	date.text = mind_save.date
	
	if is_today():
		label.visible = false
		text_edit.text = mind_save.text
		return
	
	text_edit.visible = false
	text_edit.editable = false
	label.text = mind_save.text
	saved = true


func _on_text_edit_text_changed() -> void:
	saved = false
	timer.start()


func _on_timer_timeout() -> void:
	if saved: return
	if text_edit.text.is_empty(): return
	mind_save.text = text_edit.text
	Data.save_manager.save()
	saved = true


func is_today() -> bool:
	var local_date := Time.get_date_string_from_system()
	return local_date == mind_save.date
