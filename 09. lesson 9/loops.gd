extends Node2D


const STEP: float = 150.0

func _ready() -> void:
	print("--- for with range ---")
	for i in range(6):
		print("Звезда №", i)
		
	print("--- расставляем звезды ---")
	var index: int = 0
	for star: Sprite2D in $Stars.get_children():
		star.position = Vector2(150.0 + index * STEP, 300.0)
		if index % 2 == 0:
			star.modulate = Color.GOLD
		else:
			star.modulate = Color.SKY_BLUE
		index += 1
	print("Всего звезд", index)
	
	print("--- while: яд ---")
	var hp: int = 100
	var turn: int = 0
	while hp > 0:
		turn += 1
		hp -= 17
		print("Ход ", turn, ": HP = ", maxi(hp, 0))
	print("Герой продержался ", turn, " ходов")

	print("--- break и continue ---")
	for i in range(1, 11):
		if i % 3 == 0:
			continue
		if i > 7:
			break
		print(i)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		for star: Sprite2D in $Stars.get_children():
			star.rotation_degrees += 45.0
