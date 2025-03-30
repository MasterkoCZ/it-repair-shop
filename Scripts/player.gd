extends CharacterBody2D

# Konstantní rychlost pohybu
const SPEED = 140.0
var footstep_timer: float = 0.0   # Časovač pro interval mezi kroky
var footstep_interval: float = 0.3

# Odkaz na AnimatedSprite2D uzel
@onready var animated_sprite = $AnimatedSprite2D

# Proměnná pro sledování směru posledního pohybu
var last_direction_left: bool = false

func _physics_process(delta: float) -> void:
	# Získání směru pohybu jako 2D vektor
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# Nastavení rychlosti podle směru a hodnoty SPEED
	velocity = direction * SPEED

	# Změna animace podle pohybu
	if direction.length() == 0:
		# Pokud je poslední směr doleva, otoč "idle" animaci zrcadlově
		animated_sprite.flip_h = last_direction_left
		animated_sprite.play("idle")  # Pokud není pohyb, přehraj animaci "idle"
	else:
		if direction.x < 0:
			# Pokud se pohybuje doleva, přehraj "run" a otoč grafiku zrcadlově
			animated_sprite.play("run")
			animated_sprite.flip_h = true
			last_direction_left = true  # Uloží poslední směr doleva
		else:
			# Pokud se pohybuje doprava, přehraj "run"
			animated_sprite.play("run")
			animated_sprite.flip_h = false
			last_direction_left = false  # Uloží poslední směr doprava
	if velocity != Vector2.ZERO:  # Pokud se hráč pohybuje
		footstep_timer -= delta
		if footstep_timer <= 0 and $FootstepSound and not $FootstepSound.playing:
			$FootstepSound.play()
			footstep_timer = footstep_interval  # Reset časovače
	else:
		if $FootstepSound and $FootstepSound.playing:  # Zastavení zvuku, když stojí
			$FootstepSound.stop()

	# Pohyb postavy
	move_and_slide()
