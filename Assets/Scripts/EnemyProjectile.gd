class_name EnemyProjectile
extends Node2D

@onready var area: Area2D = $Area2D;

var speed = 150;
var active = false;

func reset() -> void:
	active = false;
	position = Vector2(-10, -10); 

func _ready() -> void:
	reset();
	area.body_entered.connect(_on_hit);

func _on_hit(body: Node2D) -> void:
	(get_tree().current_scene as LevelManager).show_particle(position);
	reset()
	if (body.get_parent() is Barrier):
		(body.get_parent() as Barrier).take_damage(10);
	if (body.get_parent() is Player):
		(body.get_parent() as Player).death();

func _physics_process(delta: float) -> void:
	if (active): 
		position.y += delta * speed;
		if (position.y >= 360):
			(get_tree().current_scene as LevelManager).show_particle(position);
			reset()

func _draw() -> void:
	var rect = Rect2(Vector2(-1.5,-12), Vector2(3, 12));
	draw_rect(rect, Color.PALE_GREEN);
