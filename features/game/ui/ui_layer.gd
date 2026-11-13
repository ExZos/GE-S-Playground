extends CanvasLayer

@onready var hp_bar: HPBar = $UIContainer/HpBarContainer/HpBar
@onready var pause_menu: PauseMenu = $UIContainer/PauseMenu
@onready var respawn_text: RespawnText = $UIContainer/RespawnText
@onready var skill_tray: SkillTray = $UIContainer/SkillTrayContainer/SkillTray

var gameplay_scene: GameplayScene

var fps: int
var _last_is_paused: bool

var player: Player
var _last_fp_max_hp: int
var _last_fp_current_hp: int
var _last_is_dead: bool

func init(_gameplay_scene: GameplayScene) -> void:
	gameplay_scene = _gameplay_scene
	
	fps = Engine.get_physics_ticks_per_second()
	_last_is_paused = gameplay_scene.is_paused
	
	player = gameplay_scene.player
	_last_fp_max_hp = player.fp_max_hp
	_last_fp_current_hp = player.fp_current_hp
	_last_is_dead = player.is_dead
	
	hp_bar.init(SGFixed.to_int(_last_fp_max_hp), SGFixed.to_int(_last_fp_current_hp))
	pause_menu.init(_last_is_paused)
	respawn_text.init(_last_is_dead, _last_is_paused)
	skill_tray.init(fps, player.get_skills())

func _process(_delta: float) -> void:
	if player.fp_max_hp != _last_fp_max_hp:
		hp_bar.max_hp = SGFixed.to_int(player.fp_max_hp)
		
		_last_fp_max_hp = player.fp_max_hp
	
	if player.fp_current_hp != _last_fp_current_hp:
		hp_bar.current_hp = SGFixed.to_int(player.fp_current_hp)
		
		_last_fp_current_hp = player.fp_current_hp
	
	if player.is_dead != _last_is_dead:
		respawn_text.is_dead = player.is_dead
		
		_last_is_dead = player.is_dead
	
	if gameplay_scene.is_paused != _last_is_paused:
		pause_menu.is_paused = gameplay_scene.is_paused
		respawn_text.is_paused = gameplay_scene.is_paused
		
		_last_is_paused = gameplay_scene.is_paused
