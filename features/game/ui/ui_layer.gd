extends CanvasLayer

@export var game_manager: GameManager

@onready var hp_bar: HPBar = $UIContainer/HpBarContainer/HpBar
@onready var pause_menu: PauseMenu = $UIContainer/PauseMenu
@onready var respawn_text: RespawnText = $UIContainer/RespawnText
@onready var skill_tray: SkillTray = $UIContainer/SkillTrayContainer/SkillTray

var player: Player
var _last_fp_current_hp: int
var _last_is_dead: bool

var _last_is_paused: bool

func _ready() -> void:
	assert(game_manager, "%s: Game manager not assigned" % name)
	
	player = game_manager.player
	
	hp_bar.max_hp = SGFixed.to_int(player.fp_max_hp)
	hp_bar.current_hp = SGFixed.to_int(player.fp_current_hp)
	_last_fp_current_hp = player.fp_current_hp
	
	respawn_text.is_dead = player.is_dead
	_last_is_dead = player.is_dead
	
	pause_menu.is_paused = game_manager.is_paused
	respawn_text.is_paused = game_manager.is_paused
	_last_is_paused = game_manager.is_paused
	
	#skill_tray.game_manager = game_manager

func _process(delta: float) -> void:
	if player.fp_current_hp != _last_fp_current_hp:
		hp_bar.current_hp = SGFixed.to_int(player.fp_current_hp)
		
		_last_fp_current_hp = player.fp_current_hp
	
	if player.is_dead != _last_is_dead:
		respawn_text.is_dead = player.is_dead
		
		_last_is_dead = player.is_dead
	
	if game_manager.is_paused != _last_is_paused:
		pause_menu.is_paused = game_manager.is_paused
		respawn_text.is_paused = game_manager.is_paused
		
		_last_is_paused = game_manager.is_paused
