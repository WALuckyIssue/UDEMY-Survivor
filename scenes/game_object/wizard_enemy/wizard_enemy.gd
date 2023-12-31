extends CharacterBody2D


@onready var velocity_component = $VelocityComponent as VelocityComponent

var is_moving = false


func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)
	

func _process(delta: float) -> void:
	if is_moving:
		velocity_component.accelerate_to_player()
	else:
		velocity_component.decelerate()
		
	velocity_component.move(self)
	

func set_is_moving(moving: bool):
	is_moving = moving
	

func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
