extends ControlFocus

const CARTE = preload("res://all/cards/carte.tscn")

# Facteur de lissage pour un snapping fluide
@export var snap_smoothness : float = 0.15
# Facteur de ralentissement pour la décélération automatique
@export var deceleration_factor : float = 0.8
# Vitesse minimale pour activer le snapping automatique
@export var min_snap_speed : float = 30
@export var scroll_coef : float = 2.0

# Variables pour le suivi du scroll
var target_position := 0
var current_velocity := 0
var scrolling := false

var card_index : int = 0

var scroll_tween : Tween
var scroll_tween_data : TweenData


@onready var scroll: ScrollContainer = %Scroll
@onready var cards: HBoxContainer = %Cards

# Taille de chaque intervalle de snapping en pixels
var snap_interval :float = 300


func _ready() -> void:
	var all_cards_data :Array[CardData] = []
	for i: int in Data.card_group_datas.size():
		all_cards_data.append_array( Data.card_group_datas[i].cards_data )
	
	for i: int in all_cards_data.size():
		var carte : Carte = CARTE.instantiate()
		cards.add_child(carte)
		carte.card_data = all_cards_data[i]
	
	snap_interval = cards.get_child(0).custom_minimum_size.x


func _input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		scrolling = true
		current_velocity = event.relative.x * scroll_coef
		scroll.scroll_horizontal -= current_velocity
	elif event is InputEventScreenTouch and event.is_released():
		# Lorsque l'utilisateur lâche, déclenche le snapping
		scrolling = false
		snap_to_nearest_interval()
	
	# Keyboard & controller
	#elif InputHelper.is_action_just_released("right"):
	#elif InputHelper.is_action_just_released("left"):
	#elif InputHelper.is_action_just_released("up"):
	#elif InputHelper.is_action_just_released("down"):


func _process(delta):
	if not scrolling:
		# Si on ne fait pas de drag, applique la décélération et le snapping
		if absf(current_velocity) > min_snap_speed:
			# Applique la décélération
			current_velocity *= deceleration_factor
			scroll.scroll_horizontal += current_velocity * delta
		else:
			# Applique un snapping fluide vers l'intervalle cible
			var current_scroll = scroll.scroll_horizontal
			var new_scroll = lerp(current_scroll, target_position, snap_smoothness)
			scroll.scroll_horizontal = new_scroll


func snap_to_nearest_interval():
	# Calcul de la position la plus proche pour le snapping
	var current_scroll = scroll.scroll_horizontal
	var _index : int = roundi( abs(current_scroll ) / snap_interval)
	target_position = float(_index) * snap_interval


func focus(_time_scale : float = 1.0) -> void:
	super(_time_scale)


func unfocus(_time_scale: float = 1.0) -> void:
	super(_time_scale)


func go_to(_index : int) -> void:
	if not card_index + _index < cards.get_child_count() : return
	var target_pos : float = cards.get_child(_index).position + cards.separation
	scroll.scroll_horizontal = cards.get_child(_index).position.x + cards.separation
	
	return
	if scroll_tween and scroll_tween.is_running():
		scroll_tween.kill()
	scroll_tween = create_tween()
	scroll_tween_data.set_data(scroll_tween)
	scroll_tween.tween_property(scroll, "scroll_horizontal", target_pos, scroll_tween_data.duration)
