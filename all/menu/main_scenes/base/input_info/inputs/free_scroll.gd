class_name FreeScroll
extends InputInfo

signal index_changed(_new_index: int)

@export var scroll: ScrollContainer
@export var hbox: HBoxContainer
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


func _ready() -> void:
	snap_interval = hbox.get_child(0).custom_minimum_size.x


func custom_input(event: InputEvent) -> void:
	#if not InputHelper.focus_type == InputHelper.FocusType.TOUCH_SCREEN: return
	
	if event is InputEventScreenDrag:
		scrolling = true
		current_velocity = event.relative.x * scroll_coef
		scroll.scroll_horizontal -= current_velocity
	elif event is InputEventScreenTouch and event.is_released():
		# Lorsque l'utilisateur lâche, déclenche le snapping
		scrolling = false
		snap_to_nearest_interval()


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
	index_changed.emit(_index)
	target_position = float(_index) * snap_interval
