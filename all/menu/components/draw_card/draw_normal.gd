class_name DrawNormal
extends DrawCard

@export var card_per_line : int = 3
@export var space_between: float = 50


func init_positons(parent : Control, cartes_dos: Array[CarteDos]) -> void:
	var size : Vector2 = cartes_dos[0].size
	var window_size := parent.size
	
	var total_size := Vector2.ZERO
	total_size.x = size.x * card_per_line + space_between * (card_per_line -1)
	
	var nb_per_col: int = cartes_dos.size() / card_per_line
	if cartes_dos.size() % card_per_line != 0:
		nb_per_col += 1
	total_size.y = nb_per_col * size.y + (nb_per_col -1) * space_between
	
	var start_pos : Vector2 = (Vector2(window_size) - total_size) / 2
	
	for i: int in cartes_dos.size():
		var carte_dos: CarteDos = cartes_dos[i]
		var pos := start_pos
		pos.x += (size.x + space_between) * (i % card_per_line)
		pos.y += (size.y + space_between) * (i / card_per_line)

		carte_dos.position = pos


func process_positions(delta: float, cartes_dos: Array[CarteDos]) -> void:
	pass
