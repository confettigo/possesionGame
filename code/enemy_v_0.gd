extends CharacterBody2D
@onready var en_reaction: AnimatedSprite2D = $enReaction
@onready var en_body: AnimatedSprite2D = $EnBody

@onready var player: CharacterBody2D = $"../player"

@onready var player_sensor: Area2D = $playerSensor
@onready var timer: Timer = $timer

@export var speed = 100.0
const JUMP_VELOCITY = -400.0

var alertTimer = 0
#frames it takes for enemies to notice player
var maxAlertTime = 30

enum directions {UP,LEFT,DOWN,RIGHT}
var currentDirection = directions.LEFT

#for which axis and direction the enemies move
var direction

enum states {WANDER, STUN, IDLE,ALERT,POSSESSED}
var currentState=states.WANDER


var runTo = Vector2(0,0)

func _ready() -> void:
	en_reaction.visible=false


func _physics_process(_delta: float) -> void:
	
	
	#hopefully it only grabs the player. Otherwise... uh oh
	var bodies = player_sensor.get_overlapping_bodies()
	if(bodies.size()>0):
		print(alertTimer)
		en_reaction.frame=0
		en_reaction.visible=true
		timer.stop()
		alertTimer+=1;
	else:
		#reduces alert timer over time
		#removes question mark at 1
		if(alertTimer>0):
			alertTimer-=1
			if alertTimer==1:
				en_reaction.visible=false
		
	if alertTimer>=maxAlertTime && bodies.size()>0:
		#en_reaction.modulate=Color(0.963, 0.1, 0.821, 1.0)
		print("I found you!")
		Global.switchScene("res://scenes/levels/Lose Screen.tscn")
		#fail level
		#set global return to this scene
		#or exit?
	
	#state machine for non possession
	match currentState:
		states.WANDER:
			#change direction on wall hit OR timer timeout :3
			if velocity!=null && velocity==Vector2(0,0):
				#choose a random direction
				direction = randi_range(0,4);
				var timerTime = randf_range(.75,2)
				#print(timerTime)
				timer.start(timerTime)
				match direction:
					1:
						velocity.y=speed
					2:
						velocity.y=speed*-1
					3:
						velocity.x=speed
					4:
						velocity.x=speed*-1
		
		#kinda deprecited idle mode tbh
		states.IDLE:
			#modulate=Color(0.476, 0.769, 0.764, 1.0)
			velocity=Vector2(0,0)
			en_reaction.visible=false
			#wait a certain amount of time, then switch to wander
			#print("Idle")
			
			#starts so many times
			
			print("I will switch to searching soon!")
			timer.start(1)
			
		states.ALERT:
			
			
			en_reaction.frame=1
			en_reaction.visible=true
			
			
			if global_position.x > runTo.x:
				velocity.x =speed*-1
			else:
				velocity.x=speed
			
			if global_position.y > runTo.y:
				velocity.y =speed*-1
			else:
				velocity.y=speed
			
			
			if(abs(global_position)-abs(runTo)<=Vector2(5,5)):
				#prob dont go back to idle
				#hmmmmm. Wait at the palce for a second?
				#need another state for distracted?
				#if the player is found on the way, so be it
				currentState=states.WANDER
			#run towards alerted place
			
		states.POSSESSED:
			velocity = player.velocity
		states.STUN:
			#wait a bit, then switch to wander. Do not check for player while this happens
			print("Stunned")
	move_and_slide()
	
	
	#enemy direction machine
	#check velocities
	
	#non possessed sprite movement
	#if X is the main axis of movement
	if(abs(velocity.x) > abs(velocity.y)):
		if velocity.x>0:
			
			if currentState==states.POSSESSED:
				en_body.play("moveRightP")
			else:
				en_body.play("moveRight")
			player_sensor.set_rotation_degrees(180)
			currentDirection=directions.RIGHT
		else:
			if currentState==states.POSSESSED:
				en_body.play("moveLeftP")
			else:
				en_body.play("moveLeft")
			player_sensor.set_rotation_degrees(0)
			currentDirection=directions.LEFT
	#if Y is the main axis of movement
	else:
		if velocity.y<0:
			if currentState==states.POSSESSED:
				en_body.play("moveUpP")
			else:
				en_body.play("moveUp")
			player_sensor.set_rotation_degrees(90)
			currentDirection=directions.UP
		else:
			if currentState==states.POSSESSED:
				en_body.play("moveDownP")
			else:
				en_body.play("moveDown")
			player_sensor.set_rotation_degrees(270)
			currentDirection=directions.DOWN
	
	
	
	#if the player enters view for more then X seconds, change state to alert. Make enemy walk towards alerted position
	#also sets to alert with a distraction
	
	
#3 states, idle, alert, possessed
#when possessed, hide player and snap possessed char to player. 
#also make possessed a different color or something

#dont need this
func _on_area_2d_body_entered(_body: Node2D) -> void:
	#runTo=body.position
	#currentState=states.ALERT
	#print("Im alert! Running to: " , runTo)
	##ehhhh im not feeling this alert
	pass


func _on_timer_timeout() -> void:
	#print("I timed out!")
	direction = randi_range(0,4);
	velocity=Vector2(0,0)
	
func setAlert(V: Vector2):
	runTo = V
	currentState=states.ALERT
	
func possess():
	currentState=states.POSSESSED
	print("I got got")
	
func unpossess():
	currentState=states.WANDER
	print("Noooooo im normal again :( I was really into it")
