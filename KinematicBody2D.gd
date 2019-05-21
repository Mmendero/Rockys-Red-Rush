extends KinematicBody2D

var motion = Vector2() 
const UP = Vector2(0,-1)
const GRAVITY = 20
const MAXSPEED = 400
const JUMP = -550
const ACCELERATION = 35

const _FOOTBALL = preload("res://Football.tscn")

var jump_kick = false

func _physics_process(delta):
	
	var friction = false
	motion.y += GRAVITY
	
	if jump_kick == true: #Jump kick when true
		$AnimatedSprite.play("Jump_Kick")
		print("Kicking")
		if $AnimatedSprite.get_frame() == 8:
			jump_kick = false
		if Input.is_action_pressed("ui_right"): #Move while jump kicking
			movement_right()
		elif Input.is_action_pressed("ui_left"):
			movement_left()
			
	elif Input.is_action_pressed("ui_right"):
		movement_right()
		if jump_kick == false:
			$AnimatedSprite.play("Walk")
	elif Input.is_action_pressed("ui_left"):
		movement_left()
		if jump_kick == false:
			$AnimatedSprite.play("Walk")
	else:
		$AnimatedSprite.play("Idle")
		friction = true 
		
		
	if Input.is_action_just_pressed("Throw_Football") and jump_kick == false:
		var football = _FOOTBALL.instance()
		if sign($Position2D.position.x) == 1:
			football.set_football_direction(1)
		else:
			football.set_football_direction(-1)
		get_parent().add_child(football)
		football.position = $Position2D.global_position
		
	if is_on_floor():
		jump_kick = false
		if Input.is_action_pressed("ui_up"):
			motion.y = JUMP
		if friction == true:
			motion.x = lerp(motion.x,0,0.2)
		if Input.is_action_pressed("ui_down") and jump_kick == false:
			motion.x = 0
			$AnimatedSprite.play("Crouch")
	else:
		if motion.y < 0:
			if jump_kick == false:
				$AnimatedSprite.play("Jump")
				print("Jumping")
			if Input.is_action_just_pressed("Jump_Kick"): 
				print("Kick pressed")
				jump_kick = true
		elif motion.y > 0 and jump_kick == false:
			$AnimatedSprite.play("Fall")
			print("Falling")
		if friction == true:
			motion.x = lerp(motion.x,0,0.05)
		 
	 
	motion = move_and_slide(motion,UP) 
	
func movement_right():
		motion.x = min(motion.x + ACCELERATION,MAXSPEED)
		$AnimatedSprite.flip_h = false
		if sign($Position2D.position.x) == -1:
			$Position2D.position.x *= -1

func movement_left():
	motion.x = max(motion.x - ACCELERATION, -MAXSPEED)
	$AnimatedSprite.flip_h = true
	if sign($Position2D.position.x) == 1:
		$Position2D.position.x *= -1
	