extends Control

onready var _menu_options = get_node("MenuOptions") as VBoxContainer
export(String, FILE, "*.tscn") var _level_1_path
export(String, FILE, "*.tscn") var _level_2_path
export(String, FILE, "*.tscn") var _level_3_path
export(String, FILE, "*.tscn") var _level_4_path
export(String, FILE, "*.tscn") var _main_menu_path

var _selector : int = 0
var _MAX_MENU : int = 4
var _MIN_MENU : int = 0
var _current_label : Label

func _ready():
	self._current_label = self._menu_options.get_child(self._selector) as Label
	self._current_label.add_color_override("font_color", Color(0,0,0))

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		self._current_label.add_color_override("font_color", Color(1,1,1))
		if self._MIN_MENU != _selector:
			self._selector -= 1
	elif Input.is_action_just_pressed("ui_down"):
		self._current_label.add_color_override("font_color", Color(1,1,1))
		if self._MAX_MENU != _selector:
			self._selector += 1
	elif Input.is_action_just_pressed("ui_accept"):
		ui_accept()
	self._current_label = self._menu_options.get_child(self._selector) as Label
	self._current_label.add_color_override("font_color", Color(0,0,0))

# This function completes and action depending on where the current _selector
# variables is pointing to. In this case it goes to the specified level or the main menu.
func ui_accept() -> void:
	if self._selector == 0:
		get_tree().change_scene(self._level_1_path)
	elif self._selector == 1:
		get_tree().change_scene(self._level_2_path)
	elif self._selector == 2:
		get_tree().change_scene(self._level_3_path)
	elif self._selector == 3:
		get_tree().change_scene(self._level_4_path)
	elif self._selector == 4:
		get_tree().change_scene(self._main_menu_path)
