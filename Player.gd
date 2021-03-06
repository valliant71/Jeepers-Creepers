extends Area2D
signal hit


export var speed = 400 # How fast the player will move (pixel/sec).
var screen_size 

# variable to hold the clicked position
var target = Vector2()

func _ready():
	hide()
	screen_size = get_viewport_rect().size
	
# player input
func _process(delta):
	var velocity = Vector2() # Players movement vector
	
	# Move towards the target and stop when close
	if position.distance_to(target) > 10:
		velocity = target - position
	
	# Keyboard controls (Saving if needed later)
#	if Input.is_action_pressed('ui_right'):
#		velocity.x += 1
#	if Input.is_action_pressed('ui_left'):
#		velocity.x -= 1
#	if Input.is_action_pressed("ui_down"):
#		velocity.y += 1
#	if Input.is_action_pressed("ui_up"):
#		velocity.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.animation = "idle"
		
	# Restricting player to the bounds of the screen size
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# Animating the player to the movment of keys
	if velocity.x != 0:
		$AnimatedSprite.animation = "walk"
		if velocity.x < 0:
			$AnimatedSprite.flip_h = true
		else:
			$AnimatedSprite.flip_h = false
#	if velocity.y != 0:
#		$AnimatedSprite.animation = "up"
#		if velocity.y < 0:
#			$AnimatedSprite.flip_v = false
#		else:
#			$AnimatedSprite.flip_v = true
	

# Disables player when an enemy collides with our 2d collision box (player dissapears on screen along with the collider)
func _on_Player_body_entered(_body):
	hide() # Player dissapears after being hit
	emit_signal('hit')
	$CollisionShape2D.set_deferred('disabled', true)
	
func start(pos):
	position = pos
	
	# Initial target is the start position(click)
	target = pos
	
	show()
	$CollisionShape2D.disabled = false
	
# Change the target whenever a touch event happens
func _input(event):
	if event is InputEventScreenTouch and event.pressed:
		target = event.position
		
