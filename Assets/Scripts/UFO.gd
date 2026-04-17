class_name UFO
extends Sprite2D

var speed = 75;
var active = false;
var direction = 1.0;

func reset() -> void:
	active = false;
	position = Vector2(-10, -50); 

func spawn() -> void:
	active = true;
	direction = -1.0 if randf() < 0.5 else 1.0;
	position.x = -32 if direction == 1.0 else 672;
	position.y = 20;

func _ready() -> void:
	reset();

func _physics_process(delta: float) -> void:
	if (active):
		position.x += direction * delta * speed;
		if ((direction == 1.0 and position.x > 672) or (direction == -1.0 and position.x < -32)):
			reset()

func death():
	#drop bonus
	reset()
