extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
#do we need jump velocity? - lucie

var animatedSprite

func _ready():
	#this bit imports the animatedSprite2D that's a child of player so we can control it's animations in the player body
	#idk if we care about best practices rn but if you think it should be handled via a script on the sprite itself instead of this script using signals or whatever
	#i could redo it :D - lucie
	animatedSprite = get_node("AnimatedSprite2D")

func _physics_process(delta: float) -> void:

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("in_left", "in_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	
	var directionVert = Input.get_axis("in_up", "in_down")
	if directionVert:
		velocity.y = directionVert * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
	
	
	#animation code
	if velocity.x == velocity.y && velocity.y == 0:
		animatedSprite.play("idle")
		#this should probably be changed so it plays a different idle animation depending on the direction the player was last moving in...
		#also it's SUPER inefficiently written code but. it's 2:07 am.... - lucie
	elif velocity.x < 0:
		animatedSprite.play("leftFloat")
	elif velocity.x > 0:
		animatedSprite.play("rightFloat")
	elif velocity.y < 0:
		animatedSprite.play("upFloat")
	elif velocity.y > 0:
		animatedSprite.play("downFloat")
	
	move_and_slide()
