extends KinematicBody2D

onready var _player_animation_sprite = get_node("PlayerAnimatedSprite") as AnimatedSprite
export(Resource) onready var _hazard_tile_set = _hazard_tile_set as TileSet
# got help with this here: https://www.reddit.com/r/godot/comments/9rh5tt/exporting_a_scene_path/
export(String, FILE, "*.tscn") var _current_scene_path
export(String, FILE, "*.tscn") var _next_level_scene_path

var _velocity := Vector2(0,0)

const _JUMP_FORCE = -1100
const _SPEED = 400
const _GRAVITY = 60
const _WALL_FALL_SPEED = 200
const _WALL_JUMP_SPEED = 300

var _left_wall_jump : bool = false
var _right_wall_jump : bool = false
var _time : float = 0
const _WALL_JUMP_TIME : float = 0.4

class_name Player

func _ready():
	GameEvents.connect("enemy_touched", self, "_reset_level")

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
	
	if is_on_ceiling():
		self._velocity.y = 0
		
	if is_on_wall() and not is_on_floor() and self._velocity.y > 5:
		self._velocity.y = self._WALL_FALL_SPEED
	
	if not is_on_floor():
		self._velocity.y += self._GRAVITY
	else:
		self._velocity.y = 5
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
				self._velocity.x = self._WALL_JUMP_SPEED
			else:
				self._velocity.x = -self._WALL_JUMP_SPEED
	
	move_and_slide(self._velocity, Vector2.UP)
	if is_touching_hazardous_tiles():
		_reset_level()
	
	self._velocity.x = lerp(self._velocity.x, 0, 0.2)
	if abs(self._velocity.x) < 20:
		self._player_animation_sprite.stop()

		
func _reset_level():
	get_tree().change_scene(self._current_scene_path)
	
func is_touching_hazardous_tiles() -> bool:
	for i in get_slide_count():
		var collider = get_slide_collision(i)
		if collider.collider is TileMap and collider.collider.tile_set == self._hazard_tile_set:
				return true
	return false
		


func _on_EndOfLevel_body_entered(body):
	if body == self:
		get_tree().change_scene(self._next_level_scene_path)


func _on_FallZone_body_entered(body):
	if body == self:
		_reset_level()
