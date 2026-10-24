extends Sprite2D

const MAX_HP: int = 100
const HEIGHT: float = 648.00
const WIDTH: float = 1152.00
const CORNER: float = 90.51 #половина диагонали квадрата со стороной 128



@export var hero_name: String = "Пустое имя"
@export_range(200.00, 500.00) var default_speed: float = 200.0
@export_range(1, 10) var level: int = 1
@export var damage_point: int = 10
@export var heal_point: int = 10


var status: String = "здоров"
var hp: int = MAX_HP
var gold: int = 0
var is_alive: bool = true





func _ready() -> void:
	print("=== ", hero_name, " ===")
	print("Уровень: ", level)
	print("HP: ", hp)
	print("Скорость: ", default_speed)
	print("Жив: ", is_alive)
	update_status()

func _process(delta: float) -> void:
	var speed: float = default_speed
	
	if Input.is_action_pressed("ui_accept") and status != "при смерти":
		speed *= 2

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
			update_status()
			
		if Input.is_action_just_pressed("ui_focus_next"):
			hp += heal_point
			update_status()
			
		hp = clampi(hp, 0, MAX_HP)
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
			self.modulate = Color.WHITE
		"ранен":
			self.modulate = Color.YELLOW
		"при смерти":
			self.modulate = Color.RED
		"убит":
			self.modulate = Color.BLACK #GRAY не видно изменений
		_:
			print("неверное значение")
	
