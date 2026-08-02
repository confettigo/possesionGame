extends CharacterBody2D
#if we have time, i'd still like to implement the more floaty movement when you're the ghost... - lucie
@export var topspeed: float

var animatedSprite

func _ready():
	#this bit imports the animatedSprite2D that's a child of player so we can control it's animations in the player body
	#idk if we care about best practices rn but if you think it should be handled via a script on the sprite itself instead of this script using signals or whatever
	#i could redo it :D - lucie
	animatedSprite = get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:

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
