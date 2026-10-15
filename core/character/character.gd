@tool
extends SGCharacterBody2D

class_name Character

@export var collision_shape: SGCollisionShape2D
@export var skill_manager: SkillManager

@export var attack_type: StringName
@export var skill_types: Array[StringName]

const IS_DAMAGEABLE: bool = true
const CHARACTER_MODIFIERS_POOL_SIZE: int = 5

var character_data: CharacterData

# Dimensions
var fp_half_width: int
var fp_half_height: int

# Stats
var fp_max_hp: int
var fp_base_speed: int

# Computed stats
var fp_current_hp: int
var _fp_speed: int

# Stat modifiers
var fp_speed_add: int = 0
var fp_speed_mult_sum: int = SGFixed.ONE
var fp_speed_mult_prod: int = SGFixed.ONE

# Core state
var team: DamageSystem.Team
var is_active: bool
var is_dead: bool
var _normal_collision_layer: int   
var _normal_collision_mask: int

# Restriction states
var is_recovering: bool
var restrict_attack: bool
var restrict_skills: bool

# Tickers
var fp_recovery_ticks: int = 0

# Movement
var mov_dir: Vector2i = Vector2i.ZERO
var forced_mov_dir: Vector2i = Vector2i.ZERO

# 
var _character_modifiers: SparseFixedArray
var _character_modifiers_is_dirty: bool = false

func _validate_property(property: Dictionary) -> void:
	var skill_type_hint: String = ",".join(RegistryKeys.Skills.LIST)
	
	if property.name == "attack_type":
		property.hint = PROPERTY_HINT_ENUM
		property.hint_string = skill_type_hint
		
	if property.name == "skill_types":
		property.hint = PROPERTY_HINT_ARRAY_TYPE
		property.hint_string = "%d/%d:%s" % [TYPE_STRING_NAME, PROPERTY_HINT_ENUM, skill_type_hint]

func init(data: CharacterData) -> void:
	character_data = data
	
	if collision_shape.shape is SGRectangleShape2D:
		collision_shape.shape.extents.x = SGFixed.from_int(data.half_width)
		collision_shape.shape.extents.y = SGFixed.from_int(data.half_height)
	elif collision_shape.shape is SGCircleShape2D:
		collision_shape.shape.radius = SGFixed.from_int(data.half_width)
	
	# TODO: handle other shapes
	
	fp_half_width = data.fp_half_width
	fp_half_height = data.fp_half_height
	
	fp_max_hp = data.fp_max_hp
	fp_current_hp = data.fp_max_hp
	
	fp_base_speed = data.fp_base_speed
	_compute_speed()
	
	team = DamageSystem.Team.NEUTRAL
	is_active = true
	is_dead = false
	
	_normal_collision_layer = collision_layer
	_normal_collision_mask = collision_mask
	
	_character_modifiers = SparseFixedArray.new(CHARACTER_MODIFIERS_POOL_SIZE, TYPE_OBJECT, CharacterModifier)
	
	skill_manager.init(self, attack_type, skill_types)

func reset() -> void:
	# TODO: reset dimensions
	
	fp_max_hp = character_data.fp_max_hp
	fp_current_hp = character_data.fp_max_hp
	
	fp_base_speed = character_data.fp_base_speed
	_compute_speed()
	
	is_dead = false
	
	# TODO: reset character modifiers

func activate(fp_pos_x: int, fp_pos_y: int) -> void:
	reset()
	
	is_active = true
	
	fixed_position_x = fp_pos_x
	fixed_position_y = fp_pos_y
	
	collision_layer = _normal_collision_layer
	collision_mask = _normal_collision_mask
	
	show()
	
	sync_to_physics_engine()

func deactivate() -> void:
	is_active = false
	
	collision_layer = 0
	collision_mask = 0
	
	hide()

func advance_frame(input_mask: int, prev_input_mask: int) -> void:
	if is_dead:
		deactivate()
	
	var just_pressed_mask: int = input_mask & ~prev_input_mask
	var just_released_mask: int = ~input_mask & prev_input_mask
	
	# Process tickers
	skill_manager.process_tickers()
	
	for i in range(_character_modifiers.max_size):
		# Check if modifier's ticker expired
		if _character_modifiers.data[i] and not _character_modifiers.data[i].tick_and_check():
			remove_modifier_at(i)
	
	is_recovering = fp_recovery_ticks > 0
	if is_recovering:
		fp_recovery_ticks -= SGFixed.ONE
	
	# Handle movement inputs
	if input_mask & InputConstants.Bit.MOVE_LEFT: mov_dir.x = -1
	elif input_mask & InputConstants.Bit.MOVE_RIGHT: mov_dir.x = 1
	else: mov_dir.x = 0
	
	if input_mask & InputConstants.Bit.MOVE_UP: mov_dir.y = -1
	elif input_mask & InputConstants.Bit.MOVE_DOWN: mov_dir.y = 1
	else: mov_dir.y = 0
	
	# Attack and skill activations (since attack is also a skill)
	skill_manager.advance_frame(input_mask, just_pressed_mask, just_released_mask, mov_dir)
	
	# Apply modifiers
	if _character_modifiers_is_dirty:
		# Reset stats
		fp_speed_add = 0
		fp_speed_mult_sum = SGFixed.ONE
		fp_speed_mult_prod = SGFixed.ONE
		forced_mov_dir = Vector2i.ZERO
		
		# Reset restrictions
		restrict_attack = false
		restrict_skills = false
		
		for mod: CharacterModifier in _character_modifiers.data:
			if mod:
				mod.apply()
		
		_compute_speed()
		_character_modifiers_is_dirty = false
	
	# Movement
	if is_recovering:
		return
		
	var effective_mov_dir: Vector2i = mov_dir
	if forced_mov_dir != Vector2i.ZERO: effective_mov_dir = forced_mov_dir
	
	velocity.x = effective_mov_dir.x * _fp_speed
	velocity.y = effective_mov_dir.y * _fp_speed
	
	move_and_slide()

# --- Skill manager getters ---
func get_attack() -> Skill:
	return skill_manager._attack

func get_skills() -> Array[Skill]:
	return skill_manager._skills

# --- Restriction state utilities ---
func check_restrict_attack() -> bool:
	return restrict_attack or is_recovering

func check_restrict_skills() -> bool:
	return restrict_skills or is_recovering

# --- Character modifier wrappers ---
func add_modifier(modifier: CharacterModifier) -> void:
	if _character_modifiers.add_item(modifier) == -1:
		_character_modifiers.forced_expand("Character -> Character modifiers", 1)
		
		_character_modifiers.add_item(modifier)
	
	_character_modifiers_is_dirty = true

func remove_modifier_at(index: int) -> void:
	_character_modifiers.remove_item_at(index)
	_character_modifiers_is_dirty = true

func remove_modifier(modifier: CharacterModifier) -> void:
	_character_modifiers.remove_item(modifier)
	_character_modifiers_is_dirty = true

# --- Projectile request wrappers ---
func add_projectile_request(_request: ProjectileRequest) -> void:
	pass

func clear_projectile_requests() -> void:
	pass

# ---  ---
# TODO: consider making movement system in core/systems
func _compute_speed() -> void:
	_fp_speed = SGFixed.mul(fp_base_speed + fp_speed_add, SGFixed.mul((fp_speed_mult_sum), fp_speed_mult_prod))
