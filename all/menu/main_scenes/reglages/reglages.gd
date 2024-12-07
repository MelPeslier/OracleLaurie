extends ControlFocus

func _on_reset_button_clicked() -> void:
	Data.save_manager = SaveManager.reset()
	Data.save_manager.save()
