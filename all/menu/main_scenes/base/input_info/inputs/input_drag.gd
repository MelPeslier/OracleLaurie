class_name InputDrag
extends InputInfo


@export var tirage_groupe : TirageGroupe = null : set = _set_tirage_groupe


func custom_input(event: InputEvent) -> void:
	if not tirage_groupe: return
	if tirage_groupe.choosen_card_ref : return
	# Si carte non tirée : regarde pour les actions à faire
	
	if event is InputEventMouseMotion:
		pass
	elif event is InputEventJoypadMotion: #TODO add this / key inputs to switch from card to card
		pass
	elif event is InputEventScreenTouch:
		pass



func _set_tirage_groupe(_tirage_groupe: TirageGroupe) -> void:
	tirage_groupe = _tirage_groupe
