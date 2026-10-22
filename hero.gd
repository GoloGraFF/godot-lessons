extends Sprite2D

var speed: float = 500
var moving: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Данил запустил игру, скорость ", speed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_speed = speed
	if Input.is_action_pressed("ui_accept"):
		new_speed = speed * 2
	if Input.is_action_pressed("ui_right"):
		position.x += new_speed * delta
		moving = true
	if Input.is_action_pressed("ui_left"):
		position.x -= new_speed * delta
		moving = true
	if Input.is_action_pressed("ui_down"):
		position.y += new_speed * delta
		moving = true
	if Input.is_action_pressed("ui_up"):
		position.y -= new_speed * delta
		moving = true
	if moving:
		rotation += 2.0 * delta
		moving = false
