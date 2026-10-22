extends Sprite2D

var speed: float = 200.0

func _ready() -> void:
	print(name)
var height: float = 648.00
var wigth: float = 1152.00
var corner: float = 90.51 #половина диагонали квадрата со стороной 128

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
