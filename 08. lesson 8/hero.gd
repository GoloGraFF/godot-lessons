extends Sprite2D

const MAX_HP: int = 100
const HEIGHT: float = 648.00
const WIDTH: float = 1152.00
const CORNER: float = 90.51 #половина диагонали квадрата со стороной 128
const FOREST: Vector2 = Vector2(0, WIDTH/3.0)
const VILLAGE: Vector2 = Vector2(WIDTH/3.0, WIDTH*2.0/3.0)
const CASTLE: Vector2 = Vector2(WIDTH*2.0/3.0, WIDTH)




@export var hero_name: String = "Пустое имя"
@export_range(200.00, 500.00) var default_speed: float = 200.0
@export_range(1, 10) var level: int = 1
@export var damage_point: int = 10
@export var heal_point: int = 10


var status: String = "здоров"
var hp: int = MAX_HP
var gold: int = 0
var is_alive: bool = true
var zone: String




func _ready() -> void:
	#print("=== ", hero_name, " ===")
	#print("Уровень: ", level)
	#print("HP: ", hp)
	#print("Скорость: ", default_speed)
	#print("Жив: ", is_alive)
	update_status()
	decide_zone()
	
	
	
func _process(delta: float) -> void:
	print_zone()
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
		position.x = clamp(position.x, CORNER, WIDTH-CORNER)
		position.y = clamp(position.y, CORNER, HEIGHT-CORNER) 
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
			
		
		$HPLabel.text = "HP: " + str(hp) + "/" + str(MAX_HP) + " (" + status + ")" 
		if hp == 0:
			is_alive = false
			print(hero_name, " пал")
		decide_zone()

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
	
func decide_zone() -> void:
	if position.x >= FOREST.x and position.x <= FOREST.y:
		zone = "FOREST"
	elif position.x >= VILLAGE.x and position.x <= VILLAGE.y:
		zone = "VILLAGE"
	elif position.x >= CASTLE.x and position.x <= CASTLE.y:
		zone = "CASTLE"
	else:
		zone = "OUTSIDE ZONE"

func print_zone() -> void:
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
