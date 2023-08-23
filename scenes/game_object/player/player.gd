extends CharacterBody2D

var number_colliding_bodies = 0
var base_speed = 0

@onready var damage_interval_timer: Timer = $DamageIntervalTimer
@onready var health_component: Node = $HealthComponent
@onready var healthbar: ProgressBar = $Healthbar
@onready var abilities: Node = $Abilities
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pivot: Node2D = $Pivot
@onready var velocity_component: Node = $VelocityComponent



func _ready() -> void:
	base_speed = velocity_component.max_speed
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_interval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


func _process(delta: float) -> void:
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 or movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")


func get_movement_vector():
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement, y_movement)


func check_deal_damage():
	if number_colliding_bodies == 0 or not damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	
	
func update_health_display():
	healthbar.value = health_component.get_health_percent()


func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()


func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	

func on_damage_interval_timer_timeout():
	check_deal_damage()


func on_health_changed():
	GameEvents.emit_player_damaged()
	update_health_display()
	

func on_ability_upgrade_added(ability_upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * current_upgrades["player_speed"]["quantity"]* 0.1)
