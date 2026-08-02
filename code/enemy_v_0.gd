extends CharacterBody2D
@onready var en_reaction: AnimatedSprite2D = $enReaction
@onready var en_body: AnimatedSprite2D = $EnBody

@onready var player_sensor: Area2D = $playerSensor
@onready var timer: Timer = $timer

@export var speed = 100.0
const JUMP_VELOCITY = -400.0



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
	
	match currentState:
		states.WANDER:
			en_reaction.visible=false
			
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
				currentState=states.IDLE
			#run towards alerted place
			
		states.POSSESSED:
			#the player has control
			print("Possessed :3")
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
			en_body.play("moveRight")
			player_sensor.set_rotation_degrees(180)
			currentDirection=directions.RIGHT
		else:
			en_body.play("moveLeft")
			player_sensor.set_rotation_degrees(0)
			currentDirection=directions.LEFT
	#if Y is the main axis of movement
	else:
		if velocity.y<0:
			en_body.play("moveUp")
			player_sensor.set_rotation_degrees(90)
			currentDirection=directions.UP
		else:
			en_body.play("moveDown")
			player_sensor.set_rotation_degrees(270)
			currentDirection=directions.DOWN
	
	
	
	#if the player enters view for more then X seconds, change state to alert. Make enemy walk towards alerted position
	#also sets to alert with a distraction
	
	
#3 states, idle, alert, possessed
#when possessed, hide player and snap possessed char to player. 
#also make possessed a different color or something


func _on_area_2d_body_entered(body: Node2D) -> void:
	runTo=body.position
	currentState=states.ALERT
	print("Im alert! Running to: " , runTo)


func _on_timer_timeout() -> void:
	#print("I timed out!")
	direction = randi_range(0,4);
	velocity=Vector2(0,0)
