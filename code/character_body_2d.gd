extends CharacterBody2D
#if we have time, i'd still like to implement the more floaty movement when you're the ghost... - lucie
@export var topspeed: float
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var possession_check: Area2D = $possessionCheck

@onready var collision: CollisionShape2D = $collision


var currentAnimation

var possTimer=0
var possMax=200

var possessedBody

func _physics_process(delta: float) -> void:
	
	
	#posssesion code. PossTimer and possMax is just a countdown mechanic. 200 frames of possession
	if Input.is_action_just_released("possess"):
		if possession_check.get_overlapping_bodies().size() >=1:
			possessedBody = possession_check.get_overlapping_bodies()[0]
			possessedBody.possess()
			possTimer=1
			#call disable on functional bodies
			possess()
	#print(possTimer)
	if possTimer>=1:
		possTimer+=1
	if possTimer>=possMax:
		unpossess()
		possTimer=0
	
	
	
	
	
	if Input.is_action_just_pressed("shove"):
		currentAnimation = animatedSprite.get_animation()
		if currentAnimation == "upFloat":
			animatedSprite.play("upAttack")
			await get_tree().create_timer(0.5).timeout
			animatedSprite.play("upFloat")
		elif currentAnimation == "downFloat":
			animatedSprite.play("downAttack")
			await get_tree().create_timer(0.5).timeout
			animatedSprite.play("downFloat")
		elif currentAnimation == "leftFloat":
			animatedSprite.play("leftAttack")
			await get_tree().create_timer(0.5).timeout
			animatedSprite.play("leftFloat")
		elif currentAnimation == "rightFloat":
			animatedSprite.play("rightAttack")
			await get_tree().create_timer(0.5).timeout
			animatedSprite.play("rightFloat")
		
	
	var direction = Input.get_axis("in_left", "in_right")
	if direction:
		velocity.x = direction * topspeed
	else:
		velocity.x = move_toward(velocity.x, 0, topspeed)
		
	
	var directionVert = Input.get_axis("in_up", "in_down")
	if directionVert:
		velocity.y = directionVert * topspeed
	else:
		velocity.y = move_toward(velocity.y, 0, topspeed)
	
	
	#animation code
	if velocity.x == velocity.y && velocity.y == 0:
		animatedSprite.pause()
	elif velocity.x < 0:
		animatedSprite.play("leftFloat")
	elif velocity.x > 0:
		animatedSprite.play("rightFloat")
	elif velocity.y < 0:
		animatedSprite.play("upFloat")
	elif velocity.y > 0:
		animatedSprite.play("downFloat")
	
	move_and_slide()


func possess():
	animatedSprite.modulate = Color(0.0, 0.0, 0.0, 0.141)
	#should we disable collision? helps move around walls, but removes ability to be seen by enemies?
	collision.disabled=true
	
	
func unpossess():
	possessedBody.unpossess()
	animatedSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
	collision.disabled=false
