extends Area2D

var talkable = false
var neutral = "res://graphics/goobers/goober (test)/portrait_neutral.png"
var sad = "res://graphics/goobers/goober (test)/portrait_disappointment.png"
var the_joy = "res://graphics/goobers/goober (test)/portrait_emotional.png"
var big_joy = "res://graphics/goobers/goober (test)/portrait_huzzah.png"

var lines = [
	["i am a test line of dialogue", "i am a second test line", "if you can read this it means this is working", "hopefully now lines will repeat themselves", "this is it, hopefully now if i write an exceedingly long and meandering message, the words will wrap around"],
	["second interaction? please work", "SLOW LINE OF DIALOGUE"],
	["third interaction?? my oh my, i do have a lot of dialogue, don't i?", "i am now testing sound.      a        a        aa     aaaaa       aaa"],
	["okay, that's about it from me."],
	["SIX!!!", "SIX LINES OF DIALOGUE"],
	["ME AND MICHAEL", "(WOOAAAOAA)", "SOLID AS THEY COME", "(WOOAHAAA)"]
	
	]


var portraits = [
	[neutral, sad, neutral, the_joy, big_joy],
	[sad, big_joy],
	[the_joy, big_joy],
	[neutral],
	[neutral, big_joy],
	[neutral, the_joy, big_joy, the_joy]
]

var speeds = [
	[0.03, 0.03, 0.03, 0.03, 0.03, 0.03],
	[0.05, 0.2],
	[0.05, 0.03],
	[0.01],
	[0.03, 0.01],
	[0.05, 0.07, 0.1, 0.15]
]

var times_talked = 0
signal nomoving()
signal alrightmaybejustalittlemoving()
var is_reading = false
var completed_scenes = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Prompt.modulate = Color(1, 1, 1, 0)
	hide_all()
	completed_scenes = 0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("dash") and talkable and not is_reading:
		nomoving.emit()
		if completed_scenes >= len(lines):
			completed_scenes = len(lines)-1
			times_talked = 0
		show_all()
		if times_talked < len(lines[completed_scenes]):
			is_reading = true
			read_line(lines[completed_scenes][0 + times_talked], speeds[completed_scenes][0 + times_talked])
			$Bubble/Portrait.texture = load(portraits[completed_scenes][0 + times_talked])
		
	if Input.is_action_just_released("dash") and talkable:
		times_talked += 1
		if times_talked > len(lines[completed_scenes]):
			times_talked = 0
			hide_all()
			
			completed_scenes += 1
			if completed_scenes >= len(lines):
				completed_scenes = len(lines)-1
				
			alrightmaybejustalittlemoving.emit()

func _on_body_entered(_body):
	var tween = get_tree().create_tween()
	
	talkable = true
	tween.tween_property($Prompt, "modulate", Color(1, 1, 1, 1), 0.1).from(Color(1, 1, 1, 0))
	$Prompt.modulate = Color(1, 1, 1, 1)
	

func _on_body_exited(_body):
	times_talked = 0
	var tween = get_tree().create_tween()
	tween.tween_property($Prompt, "modulate", Color(1, 1, 1, 0), 0.5).from(Color(1, 1, 1, 1))
	$Prompt.modulate = Color(1, 1, 1, 0)
	talkable = false
	hide_all()
	


func hide_all():
	$Bubble/Dialogue.text = ""
	$Bubble/ColorRect2.visible = false
	$Bubble/Banner.visible = false
	$Bubble/Portrait.visible = false
	$Bubble/FrameInner.visible = false
	$Bubble/Frame.visible = false
func show_all():
	$Bubble/ColorRect2.visible = true
	$Bubble/Banner.visible = true
	$Bubble/Portrait.visible = true
	$Bubble/FrameInner.visible = true
	$Bubble/Frame.visible = true

var line_len = 0

func read_line(line, speed):
	line_len = 0
	var the_funny_words = ""
	var timerwait = true
	$Bubble/speechTimer.start()
	while line_len < len(line):
		
		show_all()
		the_funny_words += line[line_len]
		if the_funny_words[-1] != " ":
			$Speech.play()
		$Bubble/Dialogue.text = the_funny_words
		if Input.is_action_pressed("jump"):
			timerwait = false
		if Input.is_action_just_released("jump"):
			timerwait = true
		if timerwait:
			await get_tree().create_timer(speed).timeout
		line_len += 1
		
	is_reading = false
	$Bubble/speechTimer.stop()
	


func _on_speech_timer_timeout():
	pass
