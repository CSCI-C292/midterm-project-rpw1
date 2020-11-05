extends Node

signal enemy_touched

# This function emits a signal that that the player touched an enemy.
func emit_enemy_touched() -> void:
	call_deferred("emit_signal", "enemy_touched")
