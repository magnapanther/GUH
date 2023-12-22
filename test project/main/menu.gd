extends Node2D


func _on_play_pressed():
	get_tree().change_scene_to_file("res://main/rooms/start_cavern/1spawn_room.tscn")


func _on_quit_pressed():
	get_tree().quit()
