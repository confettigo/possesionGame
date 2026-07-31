extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


enum states {IDLE,ALERT,POSSESSED}
var currentState=states
func _physics_process(_delta: float) -> void:
	
	match currentState:
		states.IDLE:
			print("Idle")
		states.ALERT:
			print("Alert")
		states.POSSESSED:
			print("Possessed :3")
	pass
	
	
#3 states, idle, alert, possessed
#when possessed, hide player and snap possessed char to player. 
#also make possessed a different color or something


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("A player has entered the view port")
	#start the timer switch to alert
