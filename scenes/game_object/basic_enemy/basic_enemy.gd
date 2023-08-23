extends CharacterBody2D


@onready var velocity_component = $VelocityComponent as VelocityComponent


func _process(delta: float) -> void:
	velocity_component.accelerate_to_player()
	velocity_component.move(self)


