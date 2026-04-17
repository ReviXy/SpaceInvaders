class_name Player
extends Sprite2D

var speed = 200;
var projectileScene = preload("res://Assets/Scenes/PlayerProjectile.tscn");
var projectile: PlayerProjectile;

func _ready() -> void:
	projectile = projectileScene.instantiate();
	get_tree().current_scene.add_child.call_deferred(projectile);

func _physics_process(delta: float) -> void:
	var direction = 0;
	if(Input.is_key_pressed(KEY_A) and position.x > 22): direction += -1;
	if(Input.is_key_pressed(KEY_D) and position.x < 618): direction += 1;

	position.x += direction * delta * speed;
	
	if(Input.is_key_pressed(KEY_SPACE) and !projectile.active):
		projectile.position = position;
		projectile.active = true;

func death():
	position = Vector2(320, 335);
	(get_tree().current_scene as LevelManager).onPlayerDeath();
