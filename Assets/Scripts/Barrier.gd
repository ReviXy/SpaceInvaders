class_name Barrier
extends Sprite2D

@onready var body: StaticBody2D = $StaticBody2D
@onready var shape: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D

var hp = 100;

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func take_damage(damage) -> void:
	hp -= damage;
	if (hp <= 0): 
		visible = false;
		shape.set_deferred("disabled", true);
