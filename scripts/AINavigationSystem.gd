extends Node
class_name AINavigationSystem

# نظام التنقل الذكي للمكفوفين (Saudi AI Navigation)
# يوجه اللاعب صوتياً نحو الأهداف

var player_position: Vector3 = Vector3.ZERO
var target_position: Vector3 = Vector3.ZERO
var player_health: int = 100
var player_armor: int = 100

func _ready():
	pass

# تحديث موقع اللاعب
func update_player_position(x: float, y: float, z: float):
	player_position = Vector3(x, y, z)

# توجيه اللاعب نحو الهدف
func guide_to_target(target_x: float, target_y: float, target_z: float):
	target_position = Vector3(target_x, target_y, target_z)
	
	# حساب المسافة والزاوية
	var direction = target_position - player_position
	var distance = direction.length()
	
	# حساب الزاوية الأفقية (Azimuth)
	var azimuth = atan2(direction.z, direction.x)
	azimuth = rad2deg(azimuth)
	if azimuth < 0:
		azimuth += 360
	
	# توجيه صوتي للاعب
	var direction_text = ""
	if azimuth < 45 or azimuth > 315:
		direction_text = "أمامك"
	elif azimuth >= 45 and azimuth < 135:
		direction_text = "يمينك"
	elif azimuth >= 135 and azimuth < 225:
		direction_text = "خلفك"
	elif azimuth >= 225 and azimuth < 315:
		direction_text = "يسارك"
	
	var distance_text = "قريب جداً" if distance < 10 else "متوسط" if distance < 50 else "بعيد"
	
	print("الهدف على بعد %d متر، %s - %s" % [int(distance), direction_text, distance_text])

# إخبار اللاعب بوجود عدو
func alert_enemy_nearby(enemy_distance: float, enemy_azimuth: float):
	var direction = ""
	if enemy_azimuth < 45 or enemy_azimuth > 315:
		direction = "أمامك"
	elif enemy_azimuth >= 45 and enemy_azimuth < 135:
		direction = "يمينك"
	elif enemy_azimuth >= 135 and enemy_azimuth < 225:
		direction = "خلفك"
	elif enemy_azimuth >= 225 and enemy_azimuth < 315:
		direction = "يسارك"
	
	print("تحذير! عدو على بعد %d متر من %s" % [int(enemy_distance), direction])
	if OS.get_name() == "Android":
		OS.vibrate_handheld(200)

# الحصول على حالة اللاعب
func get_player_status() -> String:
	return "الصحة: %d/100 - الدروع: %d/100" % [player_health, player_armor]

# تحديث صحة اللاعب
func take_damage(damage: int):
	player_armor -= damage
	if player_armor < 0:
		player_health += player_armor
		player_armor = 0
	
	print("تم تلقي ضرر! الصحة الحالية: %d - الدروع: %d" % [player_health, player_armor])

func _process(delta):
	pass
