extends Sprite2D

var speed: float = 200.0

func _ready() -> void:
	print(name)


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
	if moving:
		rotation += 2.0 * delta
