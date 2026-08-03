extends StaticBody2D
@onready var alert_radius: Area2D = $alertRadius
@onready var player_interaction: Area2D = $playerInteraction
@onready var sound_effect_visual: AnimatedSprite2D = $"Sound Effect Visual"
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var piano: AnimatedSprite2D = $piano


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	piano.frame = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if(Input.is_action_just_released("shove")):
		if player_interaction.get_overlapping_bodies().size()>=1:
			callEnemies()
			piano.frame = 0
			audio.play()
			sound_effect_visual.visible = true
			await get_tree().create_timer(0.5).timeout
			sound_effect_visual.visible = false
			piano.frame = 1
	
	
	
	pass
	#check if player connects and hits activate key
	
	
	#then enable AlertRadius and set each enemy to alert, give coords, then disable alert

func callEnemies():
	print("calling neaby enmies to" , global_position)
	var bodies = alert_radius.get_overlapping_bodies()

	for n in bodies.size():
		bodies[n].setAlert(global_position)
	
	
	
