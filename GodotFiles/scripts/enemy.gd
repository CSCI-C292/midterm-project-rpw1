extends Node2D

onready var _enemy_animation_sprite = get_node("AnimatedEnemySprite") as AnimatedSprite

export var _STALL_START: float = 0.1
export var _TIME_START: float = 0.5
var _speed: float = 300
var _stall: float = self._STALL_START
var _time: float = self._TIME_START
var _is_moving_down := false

func _process(delta):
	if self.visible:
		self._enemy_animation_sprite.play("movement")
		move(delta)

func _on_Area2D_body_entered(body):
	if body is Player:
		GameEvents.emit_signal("enemy_touched")

func move(delta) -> void:
	if self._stall > 0:
		self._stall -= delta
		return
		
	if self._time <= 0:
		self._is_moving_down = not self._is_moving_down
		self._time = self._TIME_START
		self._stall = self._STALL_START
		
	if self._is_moving_down:
		self.position.y += self._speed * delta
	else:
		self.position.y -= self._speed * delta
		
	self._time -= delta
		
		
		
