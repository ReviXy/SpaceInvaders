class_name LevelManager
extends Node2D

var particlePool = [];
var activeParticles = [];
var particleScene = preload("res://Assets/Scenes/HitParticle.tscn");
var poolSize = 10;

var score = 0:
	set(value):
		score = value;
		scoreLabel.text = "Score: " + str(value);
var lives = 3:
	set(value):
		lives = value;
		livesLabel.text = "Lives: " + str(value);
var wave = 1;
var enemyCount;
var enemies = [];
var enemyScenes = {
	1: preload("res://Assets/Scenes/Enemy1.tscn"),
	2: preload("res://Assets/Scenes/Enemy2.tscn"),
	3: preload("res://Assets/Scenes/Enemy3.tscn")
};

var enemyScoreRewards = {
	"Enemy1": 10,
	"Enemy2": 20,
	"Enemy3": 40
}

var ufoScene = preload("res://Assets/Scenes/UFO.tscn");
var ufo: UFO;
var ufoChance = 0.015;

@onready var scoreLabel = $ScoreLabel;
@onready var livesLabel = $LivesLabel;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(poolSize):
		var particle: GPUParticles2D = particleScene.instantiate();
		add_child(particle);
		particlePool.append(particle);
		particle.finished.connect(return_particle.bind(particle));
	
	ufo = ufoScene.instantiate();
	get_tree().current_scene.add_child.call_deferred(ufo);
	
	score = score;
	lives = lives;
	
	spawnEnemies();

func onPlayerDeath():
	lives -= 1;
	print("Lives: ", lives);
	if (lives == 0):
		gameOver();

func gameOver():
	Engine.time_scale = 0.0;
	($GameOverPanel).visible = true;
	($GameOverPanel/FinalScoreLabel).text = "Final score: " + str(score);

func _on_restart_button_pressed() -> void:
	Engine.time_scale = 1.0;
	get_tree().change_scene_to_file("res://Assets/Scenes/MainScene.tscn");

var time = 0;
var enemyDirection = 1.0;
var flag = false;
var enemyMoveCooldown = 1.0
var enemyRect: Rect2;

func _process(delta: float) -> void:
	time += delta;
	if (time >= enemyMoveCooldown):
		time -= enemyMoveCooldown;
		
		if (randf() < ufoChance and !ufo.active):
			ufo.spawn();
		
		if (!flag and (enemyRect.position.x <= 24 || enemyRect.position.x + enemyRect.size.x >= 616)):
			for enemy in enemies: enemy.move(Vector2(0, 18));
			enemyRect.position.y += 18;
			enemyDirection *= -1;
			flag = true;
			
			if (enemyRect.position.y > 275):
				gameOver();
		else: 
			for enemy in enemies: enemy.move(Vector2(enemyDirection * 6, 0));
			enemyRect.position.x += enemyDirection * 6;
			flag = false;

func spawnEnemies():
	for i in range(11):
		var enemy = enemyScenes[3].instantiate();
		add_child.call_deferred(enemy);
		enemy.position = Vector2(110 + i * 42, 48 + 18 * (wave - 1));
		enemy.set_meta("type", "Enemy3");
		enemies.push_back(enemy);
	for i in range(11):
		var enemy = enemyScenes[2].instantiate();
		add_child.call_deferred(enemy);
		enemy.position = Vector2(110 + i * 42, 84 + 18 * (wave - 1));
		enemy.set_meta("type", "Enemy2");
		enemies.push_back(enemy);
	for i in range(11):
		var enemy = enemyScenes[1].instantiate();
		add_child.call_deferred(enemy); 
		enemy.position = Vector2(110 + i * 42, 120 + 18 * (wave - 1));
		enemy.set_meta("type", "Enemy1");
		enemies.push_back(enemy);
	calculateEnemyRect();
	enemyCount = enemies.size();
	enemyMoveCooldown = 1.0;

func onEnemyDeath(enemy):
	enemies.erase(enemy);
	score += enemyScoreRewards[(enemy as Enemy).get_meta("type")];

	if (enemies.size() == 0):
		wave += 1;
		lives += 1;
		spawnEnemies();
		return;
	
	calculateEnemyRect();
	
	if (enemies.size() < 0.25 * enemyCount): enemyMoveCooldown = 0.25;
	else:
		if (enemies.size() < 0.5 * enemyCount): enemyMoveCooldown = 0.5
		else:
			if (enemies.size() < 0.75 * enemyCount): enemyMoveCooldown = 0.75

func calculateEnemyRect():
	var minX = 640;
	var maxX = 0;
	var minY = 360;
	var maxY = 0;
	for enemy in enemies:
		if (enemy.position.x < minX): minX = enemy.position.x;
		if (enemy.position.x > maxX): maxX = enemy.position.x;
		if (enemy.position.y < minY): minY = enemy.position.y;
		if (enemy.position.y > maxY): maxY = enemy.position.y;
	enemyRect = Rect2(minX, minY, maxX - minX, maxY - minY);

#-----Particles-----

func show_particle(pos: Vector2) -> void:
	var particle = get_particle()
	if particle:
		particle.position = pos;
		particle.emitting = true;
		activeParticles.append(particle)

func get_particle() -> GPUParticles2D:
	if (particlePool.size() > 0):
		var particle = particlePool.pop_back();
		activeParticles.append(particle);
		return particle;
	else:
		var particle = activeParticles.pop_back();
		activeParticles.append(particle);
		return particle;

func return_particle(particle) -> void:
	var index = activeParticles.find(particle)
	if index != -1:
		activeParticles.remove_at(index)
		particlePool.append(particle)
