class_name Enemy
extends Sprite2D

var projectileScene = preload("res://Assets/Scenes/EnemyProjectile.tscn");
var projectile: EnemyProjectile;
var projectileChance = 0.025;

func _ready() -> void:
	projectile = projectileScene.instantiate();
	get_tree().current_scene.add_child.call_deferred(projectile);

func _process(delta: float) -> void:
	pass

func _exit_tree() -> void:
	(get_tree().current_scene as LevelManager).onEnemyDeath(self);

func move(d: Vector2) -> void:
	position += d;
	if (frame == 0): frame = 1;
	else: frame = 0;
	
	if(randf() < projectileChance and !projectile.active):
		projectile.position = position;
		projectile.active = true;
