extends Node

func body_touched():
	GameEvents.emit_signal("enemy_touched")
