class_name PlayerProjectile
extends Node2D

@onready var area: Area2D = $Area2D;

var speed = 300;
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
	if (body.get_parent() is Enemy):
		(body.get_parent() as Enemy).queue_free();
	if (body.get_parent() is UFO):
		(body.get_parent() as UFO).death();
		(get_tree().current_scene as LevelManager).score += 150;

func _physics_process(delta: float) -> void:
	if (active): 
		position.y -= delta * speed;
		if (position.y <= 0):
			(get_tree().current_scene as LevelManager).show_particle(position);
			reset()

func _draw() -> void:
	var rect = Rect2(Vector2(-1.5,0), Vector2(3, 12));
	draw_rect(rect, Color.WHITE);
