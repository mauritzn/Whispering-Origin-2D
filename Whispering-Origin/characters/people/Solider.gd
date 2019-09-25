extends KinematicBody2D

export (int) var walk_speed = 175

enum { UP, DOWN, LEFT, RIGHT }
const RAYCAST_LENGTH = 24

var velocity = Vector2()
var last_dir = DOWN
var action_ready = true

var tools = {
	"axe": {
		"name": "Bronze Axe",
		"hit_force": (100 / 3) + 1
	},
	"pickaxe": {
		"name": "Bronze Pickaxe",
		"hit_force": (100 / 3) + 1
	}
}

func handle_input():
	velocity = Vector2()
	var up = Input.is_action_pressed('ui_up')
	var down = Input.is_action_pressed('ui_down')
	var left = Input.is_action_pressed('ui_left')
	var right = Input.is_action_pressed('ui_right')

	if up:
		last_dir = UP
		velocity.y -= 1
		$RayCast2D.cast_to.x = 0
		$RayCast2D.cast_to.y = -RAYCAST_LENGTH
		if !left and !right:
			$AnimationPlayer.play("walk_up")
	if down:
		last_dir = DOWN
		velocity.y += 1
		$RayCast2D.cast_to.x = 0
		$RayCast2D.cast_to.y = RAYCAST_LENGTH
		if !left and !right:
			$AnimationPlayer.play("walk_down")
	if left:
		last_dir = LEFT
		velocity.x -= 1
		$RayCast2D.cast_to.x = -RAYCAST_LENGTH
		$RayCast2D.cast_to.y = 0
		$AnimationPlayer.play("walk_left")
	if right:
		last_dir = RIGHT
		velocity.x += 1
		$RayCast2D.cast_to.x = RAYCAST_LENGTH
		$RayCast2D.cast_to.y = 0
		$AnimationPlayer.play("walk_right")
		
	velocity = velocity.normalized() * walk_speed
		
	if not up and not down and not left and not right:
		match last_dir:
			UP:
				$AnimationPlayer.play("stand_up")
			DOWN:
				$AnimationPlayer.play("stand_down")
			LEFT:
				$AnimationPlayer.play("stand_left")
			RIGHT:
				$AnimationPlayer.play("stand_right")

func _physics_process(delta):
	handle_input()
	self.move_and_collide(velocity * delta)
	
	if Input.is_action_pressed('ui_action'):
		if action_ready:
			if $RayCast2D.is_colliding():
				if $RayCast2D.get_collider().has_method("hit"):
					action_ready = false
					$ActionTimer.start()
					$RayCast2D.get_collider().hit(self)

func _on_ActionTimer_timeout():
	action_ready = true
