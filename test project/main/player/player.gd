extends CharacterBody2D

const Globals = preload("res://globals/globals.gd")
var globals = Globals.new()


const SPEED = 30.0
const JUMP_VELOCITY = -300.0
const queuedJump = 5
const queuedWall = 5
var jumpable = false
var framesleft = 0
var coyoteTime = 3
var coyoteCounter = 0
var STAM = 2000
var stamcounter = 0
var maxwalkable = 150
var stamincrement = 1
var maxfallspeed = 300
var bonkCheck = false
var kickoff = 250

var in_dialogue_sequence = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor() and velocity.y < maxfallspeed:
		if is_on_wall_only() and velocity.y > 0:
			velocity.y += gravity * delta /2
		else:
			velocity.y += gravity * delta
	if is_on_floor():
		coyoteCounter = coyoteTime
		stamcounter = 0
	if not in_dialogue_sequence:
		if stamcounter < STAM and not bonkCheck:
			if leftclimb and  Input.is_action_pressed("climb"):
				velocity.y = 0 
				stamcounter += stamincrement*2
			if leftclimb and  Input.is_action_pressed("climb") and Input.is_action_pressed("up"):
				velocity.y = -50
				stamcounter += stamincrement*7
				
			if rightclimb and  Input.is_action_pressed("climb"):
				velocity.y = 0 
				stamcounter += stamincrement
			if rightclimb and  Input.is_action_pressed("climb") and Input.is_action_pressed("up"):
				velocity.y = -50
				stamcounter += stamincrement*7
			if leftclimb or rightclimb:
				if Input.is_action_pressed("down") and Input.is_action_pressed("climb"):
					velocity.y = 50
		literally_every_standard_jump_handler()
		
		
		framesleft += -1
		if is_on_floor() and framesleft > 0:
			velocity.y += JUMP_VELOCITY
			jumpable = true
		elif framesleft > 0:
			if leftclimb:
				velocity.y = JUMP_VELOCITY
				velocity.x += kickoff
			if rightclimb:
				velocity.y = JUMP_VELOCITY
				velocity.x += -kickoff
				
			
			
		if not is_on_floor():
			coyoteCounter += -1
		
		var direction = Input.get_axis("left", "right")
		if direction and abs(velocity.x * direction) < maxwalkable:
			
			if is_on_floor():
				velocity.x = velocity.x + direction * SPEED/3
			else:
				velocity.x = velocity.x + direction * SPEED/4
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			
		if Input.is_action_pressed("left"):
			$Sprite2D.flip_h = true
		if Input.is_action_pressed("right"):
			$Sprite2D.flip_h = false
	
	move_and_slide()
	
	

var leftclimb = false
func _on_left_climb_body_entered(_body):
	leftclimb = true


func _on_left_climb_body_exited(_body):
	leftclimb = false
	if Input.is_action_pressed("climb") and Input.is_action_pressed("up"):
		velocity.x += -50
		

var rightclimb = false


func _on_right_climb_body_entered(_body):
	rightclimb = true


func _on_right_climb_body_exited(_body):
	rightclimb = false
	if Input.is_action_pressed("climb") and Input.is_action_pressed("up"):
		velocity.x += 50

#this is the function for every type of jump (so far. subject to change.)
func literally_every_standard_jump_handler():
	
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y += JUMP_VELOCITY
			jumpable = true
			coyoteCounter = 0
		if coyoteCounter > 0:
			velocity.y = JUMP_VELOCITY
		jumpable = true
		coyoteCounter = coyoteTime
		#WALL jumps (wip)
		# WHY THE FUCK ARE THERE NEUTRAL JUMPS WHAITSDHFIA UFDAF HOW THE FUCK DIDM NEUTRAL JUMPS GET IN HERE WHAT TIUHE FUCK HID I DO
		if not is_on_floor() and framesleft == 0:
			if leftclimb:
				velocity.y = JUMP_VELOCITY
				velocity.x += kickoff
			if rightclimb:
				velocity.y = JUMP_VELOCITY
				velocity.x += -kickoff


	
	#queued jump (if pressed before hitting ground)
	if Input.is_action_just_pressed("jump") and not is_on_floor() and jumpable:
		framesleft = queuedJump
		jumpable = false
	
	if Input.is_action_just_released("jump") and not is_on_floor() and velocity.y < 0:
		velocity.y = velocity.y/3
	
	


func _on_bonk_check_body_entered(_body):
	bonkCheck = true


func _on_bonk_check_body_exited(_body):
	bonkCheck = false


func _on_test_npc_alrightmaybejustalittlemoving():
	in_dialogue_sequence = false


func _on_test_npc_nomoving():
	in_dialogue_sequence = true
	$".".velocity.x = 0
