class_name TirageGroupe
extends Control


const CARTE_DOS = preload("res://all/cards/scenes/carte_dos.tscn")


var card_group_data: CardGroupData : set = _set_card_group_data
var choosen_card_ref: CardRef = null


# Initialise
func _set_card_group_data(_card_group_data : CardGroupData) -> void:
	card_group_data = _card_group_data
	
	for i: int in card_group_data.nombre_de_cartes:
		var carte_dos: CarteDos = CARTE_DOS.instantiate()
		carte_dos.card_ref = card_group_data.cards_data[i].card_ref
		add_child( carte_dos )
		carte_dos.position = size / 2
		

 
