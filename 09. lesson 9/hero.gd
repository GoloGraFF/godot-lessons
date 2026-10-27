extends Sprite2D

const MAX_HP: int = 100
const HEIGHT: float = 648.00
const WIDTH: float = 1152.00
const CORNER: float = 90.51 #половина диагонали квадрата со стороной 128
const COMBO_COUNT: int = 6
const COMBO_DAMAGE: int = 1


@export var hero_name: String = "Пустое имя"
@export_range(200.00, 500.00) var default_speed: float = 200.0
@export_range(1, 10) var level: int = 1
@export var damage_point: int = 10
@export var heal_point: int = 10
@export var is_player: bool = true

var status: String = "здоров"
var hp: int = MAX_HP
var gold: int = 0
var is_alive: bool = true
var zone: String




func _ready() -> void:
	update_status()
	update_label()
	
func _process(delta: float) -> void:
	if not is_player:
		return
		
	update_label()
	var speed: float = default_speed
	
	if Input.is_action_pressed("ui_accept") and status != "при смерти":
		speed *= 2.0

	if is_alive:
		var moving: bool = false
		if Input.is_action_pressed("ui_left"):
			position.x -= speed * delta
			moving = true 
		if Input.is_action_pressed("ui_right"):
			position.x += speed * delta
			moving = true 
		if Input.is_action_pressed("ui_up"):
			position.y -= speed * delta
			moving = true 
		if Input.is_action_pressed("ui_down"):
			position.y += speed * delta
			moving = true
		
		position = clamp_to_screen(position)
		
		if moving:
			rotation += 2.0 * delta
		if Input.is_action_just_pressed("ui_cancel"):
			hp -= damage_point
			hp = clampi(hp, 0, MAX_HP)
			update_status()
		if Input.is_action_just_pressed("ui_focus_next"):
			hp += heal_point
			hp = clampi(hp, 0, MAX_HP)
			update_status()
		if Input.is_action_just_pressed("ui_page_down"):
			take_damage(COMBO_DAMAGE)
			
		if Input.is_action_just_pressed("ui_page_up"):
			heal()
			
		$HPLabel.text = "HP: " + str(hp) + "/" + str(MAX_HP) + " (" + status + ")" 
		if hp == 0:
			is_alive = false
			print(hero_name, " пал")


func update_status() -> void:
	if hp <= 0:
		status = "убит"
	elif hp <= 30:
		status = "при смерти"
	elif hp <= 60:
		status = "ранен"
	else:
		status = "здоров"
	
	match status:
		"здоров":
			self.self_modulate = Color.WHITE
		"ранен":
			self.self_modulate = Color.YELLOW
		"при смерти":
			self.self_modulate = Color.RED
		"убит":
			self.self_modulate = Color.BLACK #GRAY не видно изменений
		_:
			print("неверное значение")
	$HPLabel.self_modulate = get_hp_color(hp, MAX_HP)

func update_label() -> void:
	zone = get_zone(position.x)
	match zone:
		"FOREST":
			$ZoneLabel.text = "ЛЕС"
			$DangerLabel.text = ""
		"VILLAGE":
			$ZoneLabel.text = "ДЕРЕВНЯ"
			$DangerLabel.text = ""
		"CASTLE":
			$ZoneLabel.text = "ЗАМОК"
			if hp <= 30:
				$DangerLabel.text = "ОПАСНОСТЬ"
			else:
				$DangerLabel.text = ""
		"OUTSIDE ZONE":
			$ZoneLabel.text = "ЗА ПРЕДЕЛАМИ ЗОНЫ"
			$DangerLabel.text = ""
		_:
			print("произошло странное!!!")


func take_damage(amount: int) -> void:
	if not is_alive:
		return
	for i in range(1, COMBO_COUNT+1):
		print("Удар №",i, ": -", calc_damage(amount, i))
		hp -= calc_damage(amount, i)
		hp = clampi(hp, 0, MAX_HP)
		if hp <= 0:
			print("КОМБО ПРЕРВАНО")
			break
	update_status()


func heal(amount: int = 1) -> void:
	var tick: int = 0
	while hp < 50:
		hp += amount
		hp = clampi(hp, 0, MAX_HP)
		tick += 1
	if tick > 0:
		print("Потребовалось ", tick, " тиков")
	update_status()

func get_zone(x: float) -> String:
	if x >= 0 and x < WIDTH/3.0:
		return "FOREST"
	elif x <= WIDTH*2.0/3.0:
		return "VILLAGE"
	elif x <= WIDTH:
		return "CASTLE"
	else:
		return "OUTSIDE ZONE"
	

func clamp_to_screen(pos: Vector2) -> Vector2:
	return Vector2(
		clamp(pos.x, CORNER, WIDTH-CORNER), 
		clamp(pos.y, CORNER, HEIGHT-CORNER)
		)

func calc_damage(base: int, combo_step: int) -> int:
	if combo_step % 3 == 0 and combo_step != 1:
		return (base + combo_step)*2
	else:
		return base + combo_step

func get_hp_color(current: int, maximum: int) -> Color:
	var percent_hp: float = float(current) / maximum
	if  percent_hp >= 0.6:
		return Color.GREEN
	elif percent_hp >= 0.3:
		return Color.YELLOW
	elif percent_hp >= 0.01:
		return Color.RED
	else:
		return Color.BLACK
