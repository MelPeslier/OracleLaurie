extends Node
## This Script generates the cards data and the group_cards data

const IMAGE_PATH_START : String = "res://all/cards/images/"
const IMAGE_PATH_END : String = ".png"

const S : String = "_"

const TITRE : String = "TITRE"
const MOTS_CLES : String = "MOTS_CLES"
const DESCRIPTION : String = "DESCRIPTION"
const COMPLEMENT : String = "COMPLEMENT"

## Group Cards Data To generate
@export var card_group_datas : Array[CardGroupData]

## Start on ready
func _ready() -> void:
	for card_group_data : CardGroupData in card_group_datas:
		generate_group(card_group_data)


## Generate CardGroupData and each of his cards
func generate_group(_card_group_data: CardGroupData) -> void:
	# Group
	_card_group_data.mots_cles = _card_group_data.titre + S + MOTS_CLES
	_card_group_data.description = _card_group_data.titre + S + DESCRIPTION
	var base_name : String = _card_group_data.titre + S + "00"
	_card_group_data.image = load( IMAGE_PATH_START + base_name.to_lower() + IMAGE_PATH_END )
	
	# Card
	_card_group_data.cards_data.resize(0)
	for i : int in _card_group_data.nombre_de_cartes:
		var group_titre := _card_group_data.titre
		var card_id := i + 1 # Start from 1 to nombre_de_cartes inclusive
		var card_data := generate_card_data(group_titre, card_id)
		_card_group_data.cards_data.push_back(card_data)


## Generate the card data based on the number of cards wanted
func generate_card_data(_group_titre: String, _card_id: int) -> CardData:
	var card_data := CardData.new()
	# TODO Normalement pas de problème : mais vérifier que _group_titre est bien en majuscule, français et sans accents
	var base_name := _group_titre + S + id_to_str(_card_id) + S
	card_data.card_id = _card_id
	card_data.titre = base_name + TITRE
	card_data.mots_cles = base_name + MOTS_CLES
	card_data.description = base_name + DESCRIPTION
	card_data.complement = base_name + COMPLEMENT
	card_data.image = load( IMAGE_PATH_START + base_name.to_lower() + IMAGE_PATH_END )
	return card_data


## Transform a number inferior to 10 to have a '0' before : '7' -> '07'
func id_to_str(_id: int) -> String:
	var id : String = ""
	if _id < 10:
		id = "0"
	id += str(_id)
	return id
