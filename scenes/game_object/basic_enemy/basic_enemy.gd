extends CharacterBody2D


@onready var velocity_component = $VelocityComponent as VelocityComponent


func _ready() -> void:
	$HurtboxComponent.hit.connect(on_hit)

func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


func on_hit():
	$HitRandomAudioPlayerComponent.play_random()
