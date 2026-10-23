extends Sprite2D

const MAX_HP: int = 100

@export var hero_name: String = "Пустое имя"
@export_range(200.00, 500.00) var speed: float = 200.0
@export_range(1, 10) var level: int = 1
@export var damage_point:int = 10
@export var heal_point:int = 10

var hp: int = MAX_HP
var gold:int = 0
var is_alive: bool = true



var height: float = 648.00
var wigth: float = 1152.00
var corner: float = 90.51 #половина диагонали квадрата со стороной 128

func _ready() -> void:
	print("=== ", hero_name, " ===")
	print("Уровень: ", level)
	print("HP: ", hp)
	print("Скорость: ", speed)
	print("Жив: ", is_alive)


func _process(delta: float) -> void:
	$HPLabel.text = "HP: " + str(hp) + "/" + str(MAX_HP)
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
		position.x = clamp(position.x, 0+corner, wigth-corner)
		position.y = clamp(position.y, 0+corner, height-corner) 
		if moving:
			rotation += 2.0 * delta
		if Input.is_action_just_pressed("ui_cancel"):
			hp -= damage_point
		if Input.is_action_just_pressed("ui_focus_next"):
			hp += heal_point
		hp = clampi(hp, 0, MAX_HP)
		if hp == 0:
			is_alive = false
			print(hero_name, " пал")
