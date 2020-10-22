extends KinematicBody2D

onready var _player_animation_sprite = get_node("PlayerAnimatedSprite") as AnimatedSprite

var _velocity := Vector2(0,0)

const _JUMP_FORCE = -600
const _SPEED = 300
const _GRAVITY = 30

var _left_wall_jump : bool = false
var _right_wall_jump : bool = false
var _time : float = 0
const _WALL_JUMP_TIME : float = 0.4

func _physics_process(delta):
	if Input.is_action_pressed("move_right"):
		self._velocity.x = self._SPEED
		if is_on_floor():
			self._player_animation_sprite.play("run")
		self._player_animation_sprite.flip_h = false
	if Input.is_action_pressed("move_left"):
		self._velocity.x = -self._SPEED
		if is_on_floor():
			self._player_animation_sprite.play("run")
		self._player_animation_sprite.flip_h = true
	
	if not is_on_floor():
		self._velocity.y += self._GRAVITY
	else:
		self._velocity.y = 1
	if Input.is_action_just_pressed("jump") and is_on_floor():
		self._velocity.y = self._JUMP_FORCE
		self._player_animation_sprite.play("jump")
	elif Input.is_action_just_pressed("jump") and is_on_wall():
		if self._player_animation_sprite.flip_h:
			self._left_wall_jump = true
		else:
			self._right_wall_jump = true
		self._player_animation_sprite.play("wall jump")
		self._velocity.y = self._JUMP_FORCE
	
	if self._left_wall_jump or self._right_wall_jump:
		self._time += delta
		if self._time > self._WALL_JUMP_TIME:
			self._time = 0
			self._left_wall_jump = false
			self._right_wall_jump = false
			self._player_animation_sprite.play("jump")
		else:
			if self._left_wall_jump:
				self._velocity.x = 200
			else:
				self._velocity.x = -200
	
	move_and_slide(self._velocity, Vector2.UP)
	
	self._velocity.x = lerp(self._velocity.x, 0, 0.2)
	if abs(self._velocity.x) < 20:
		self._player_animation_sprite.stop()
