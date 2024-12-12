class_name FreeScroll
extends InputInfo

signal index_changed(_new_index: int)

@export var my_scroll: MyScroll = null : set = _set_my_scroll
# Facteur de lissage pour un snapping fluide
@export var snap_smoothness : float = 0.15
# Facteur de ralentissement pour la décélération automatique
@export var deceleration_factor : float = 0.8
# Vitesse minimale pour activer le snapping automatique
@export var min_snap_speed : float = 30
@export var scroll_coef : float = 3.0

# Variables pour le suivi du scroll
var target_position := 0
var current_velocity := 0
var scrolling := false


# Taille de chaque intervalle de snapping en pixels
var snap_interval :float = 300
var _index: int = -1

func _ready() -> void:
	my_scroll = my_scroll


func _set_my_scroll(_my_scroll: MyScroll) -> void:
	my_scroll = _my_scroll
	set_process(false)
	set_process_input(false)
	if not my_scroll: return
	snap_interval = _my_scroll.cards.get_child(0).custom_minimum_size.x
	var _index : int = my_scroll.card_index
	target_position = float(_index) * snap_interval
	set_process_input(true)
	set_process(true)


func custom_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			if not _index == -1 : return
			_index = event.index
			print("index ::: ", _index)
			scrolling = true
			set_process(true)
		else:
			if not _index == event.index: return
			print("ok : ", _index)
			snap_to_nearest_interval()
			scrolling = false
			_index = -1
		return
	
	if event is InputEventScreenDrag and scrolling:
		if not _index == event.index: return
		print("okokok : ", _index)
		
		current_velocity = event.relative.x * scroll_coef
		my_scroll.scroll_horizontal -= current_velocity


func _process(delta):
	if not scrolling:
		# Si on ne fait pas de drag, applique la décélération et le snapping
		if absf(current_velocity) > min_snap_speed:
			# Applique la décélération
			current_velocity *= deceleration_factor
			my_scroll.scroll_horizontal += current_velocity * delta
		else:
			# Applique un snapping fluide vers l'intervalle cible
			var current_scroll = my_scroll.scroll_horizontal
			var new_scroll = lerp(current_scroll, target_position, snap_smoothness)
			my_scroll.scroll_horizontal = new_scroll
			if is_equal_approx(new_scroll, target_position):
				set_process(false)


func snap_to_nearest_interval():
	# Calcul de la position la plus proche pour le snapping
	var current_scroll = my_scroll.scroll_horizontal
	var _index : int = roundi( abs(current_scroll ) / snap_interval)
	target_position = float(_index) * snap_interval
	index_changed.emit(_index)
