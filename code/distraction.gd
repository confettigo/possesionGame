extends StaticBody2D
@onready var alert_radius: Area2D = $alertRadius
@onready var player_interaction: Area2D = $playerInteraction


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if(Input.is_action_just_released("shove")):
		if player_interaction.get_overlapping_bodies().size()>=1:
			callEnemies()
	
	
	
	pass
	#check if player connects and hits activate key
	
	
	#then enable AlertRadius and set each enemy to alert, give coords, then disable alert

func callEnemies():
	print("calling neaby enmies to" , global_position)
	var bodies = alert_radius.get_overlapping_bodies()

	for n in bodies.size():
		bodies[n].setAlert(global_position)
	
	
	
