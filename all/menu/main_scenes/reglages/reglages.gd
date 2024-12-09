extends ControlFocus



func _on_reset_clicked() -> void:
	Data.save_manager = SaveManager.reset()
	Data.save_manager.save()
