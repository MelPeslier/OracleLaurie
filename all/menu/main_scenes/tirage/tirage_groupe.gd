class_name TirageGroupe
extends Control

signal card_choosen

const CARTE_DOS = preload("res://all/cards/scenes/carte_dos.tscn")

@export var draw_card: DrawCard

@export var cards_interval : float = 0.1
@export var carte_duration : float = 1.3
@export var td: TweenData

var tween: Tween
var card_group_data: CardGroupData : set = _set_card_group_data
var choosen_card_ref: CardRef = null

var dos: Array[CarteDos] = []

@onready var carte: Carte = %Carte
@onready var cartes_dos: Control = %CartesDos


func _ready() -> void:
	carte.visible = false
	carte.modulate.a = 0.0

# Initialise
func _set_card_group_data(_card_group_data : CardGroupData) -> void:
	card_group_data = _card_group_data
	
	# Random
	var cards_ref : Array[CardRef]
	for i: int in card_group_data.nombre_de_cartes:
		cards_ref.push_back( card_group_data.cards_data[i].card_ref )
	cards_ref.shuffle()
	
	for i: int in card_group_data.nombre_de_cartes:
		var carte_dos: CarteDos = CARTE_DOS.instantiate()
		cartes_dos.add_child( carte_dos )
		dos.push_back(carte_dos)
		carte_dos.init_type( card_group_data.image, cards_ref[i] )
		carte_dos.choosen.connect( _on_card_choosen )
	draw_card.init_positons(dos)


func _on_card_choosen(_card_ref: CardRef) -> void:
	deactivate()
	if choosen_card_ref: return
	
	card_choosen.emit()
	carte.card_data = Data.get_card_data_from_card_ref( _card_ref )
	Data.tirage_actuel.cards_ref.append( _card_ref )
	Data.save_manager.save()
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_parallel()
	td.set_data(tween)
	var duration : float = td.duration
	var target_pos_selected : float = get_window().size.y + cartes_dos.get_child(0).custom_minimum_size.y
	var others_pos : float = - cartes_dos.get_child(0).custom_minimum_size.y
	
	carte.visible = true
	
	var choosen_carte_dos: CarteDos = null
	var i: int = 0
	for carte_dos: CarteDos in cartes_dos.get_children():
		if _card_ref == carte_dos.card_ref:
			choosen_carte_dos = carte_dos
			continue
		tween.tween_property(carte_dos, "position:y", others_pos, duration)\
		.set_delay( cards_interval * float( i ) )
		i+=1
	
	tween.tween_property(choosen_carte_dos, "position:y", target_pos_selected, duration)\
		.set_delay( cards_interval * float( i ) )
	
	tween.chain().tween_property(carte, "position:y", 0.0, carte_duration).from(get_window().size.y)
	tween.parallel().tween_property(carte, "modulate:a", 1.0, 0.1)
	tween.parallel().tween_property(cartes_dos, "modulate:a", 0.0, 0.1)
	tween.chain().tween_callback( _set_card_ref.bind( _card_ref ) )

func _set_card_ref(_card_ref: CardRef) -> void:
	choosen_card_ref = _card_ref


func tap() -> void:
	if not choosen_card_ref: return
	carte.tap()


func activate() -> void:
	if choosen_card_ref: return
	for carte_dos: CarteDos in cartes_dos.get_children():
		carte_dos.activated = true


func deactivate() -> void:
	if choosen_card_ref: return
	for carte_dos: CarteDos in cartes_dos.get_children():
		carte_dos.activated = false
