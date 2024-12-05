class_name TirageGroupe
extends Control


const CARTE_DOS = preload("res://all/cards/scenes/carte_dos.tscn")


var card_group_data: CardGroupData : set = _set_card_group_data
var choosen_card_ref: CardRef = null


@onready var carte: Carte = %Carte
@onready var cartes_dos: Control = %CartesDos


func _ready() -> void:
	carte.modulate.a = 0.0

# Initialise
func _set_card_group_data(_card_group_data : CardGroupData) -> void:
	card_group_data = _card_group_data
	for i: int in card_group_data.nombre_de_cartes:
		var carte_dos: CarteDos = CARTE_DOS.instantiate()
		cartes_dos.add_child( carte_dos )
		carte_dos.init_type(card_group_data.image, card_group_data.cards_data[i].card_ref)
		#carte_dos.position = custom_minimum_size / 2


func tap() -> void:
	if not choosen_card_ref:
		choosen_card_ref = get_closest_card()
		carte.card_data = Data.get_card_data_from_card_ref( choosen_card_ref )
		carte.modulate.a = 1.0
		cartes_dos.modulate.a = 0.0
		return
		
	carte.tap()


func get_closest_card() -> CardRef: # Random For Now
	var dist: float = 5000
	var card_ref: CardRef = null
	#for 
	var carte_dos: CarteDos = cartes_dos.get_child(0)
	
	# Random
	var random_card : int = randi() % card_group_data.nombre_de_cartes
	carte_dos = cartes_dos.get_child( random_card )
	card_ref = carte_dos.card_ref
	return card_ref 
