extends Node2D

onready var _pause_menu = get_node("PauseMenu") as Control

func _process(delta):
	if Input.is_action_just_pressed("menu_start"):
		get_tree().paused = true
		self._pause_menu.visible = true
