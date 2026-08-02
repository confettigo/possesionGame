extends CharacterBody2D
#if we have time, i'd still like to implement the more floaty movement when you're the ghost... - lucie
@export var topspeed: float
@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D

var currentAnimation


func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("in_space"):
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
