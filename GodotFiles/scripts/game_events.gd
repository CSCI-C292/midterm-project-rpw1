extends Node

signal enemy_touched

func emit_enemy_touched() -> void:
	call_deferred("emit_signal", "enemy_touched")
