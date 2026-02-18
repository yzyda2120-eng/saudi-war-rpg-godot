extends Node
class_name CombatSystem

# نظام القتال المتقدم (Advanced Combat System)
# محاكاة واقعية للأسلحة مع نظام التغذية الراجعة اللمسية

class Weapon:
	var name: String
	var ammo: int
	var max_ammo: int
	var recoil_intensity: int
	
	func _init(p_name: String, p_ammo: int, p_max_ammo: int, p_recoil: int):
		name = p_name
		ammo = p_ammo
		max_ammo = p_max_ammo
		recoil_intensity = p_recoil

var arsenal: Dictionary = {}
var current_weapon: String = "صقر"
var text_to_speech: Node

func _ready():
	# إضافة أسلحة حقيقية (صقر، شاهين)
	arsenal["صقر"] = Weapon("صقر", 100, 100, 100)  # رشاش
	arsenal["شاهين"] = Weapon("شاهين", 10, 10, 250)  # قناص
	
	# البحث عن نظام النطق الصوتي
	text_to_speech = get_tree().root.get_node_or_null("TextToSpeech")

func fire_weapon():
	if current_weapon not in arsenal:
		return
	
	var weapon = arsenal[current_weapon]
	if weapon.ammo > 0:
		weapon.ammo -= 1
		print("إطلاق نار بسلاح %s. الذخيرة المتبقية: %d" % [weapon.name, weapon.ammo])
		
		# محاكاة الارتداد (Recoil) باستخدام الاهتزاز
		if OS.get_name() == "Android":
			OS.vibrate_handheld(weapon.recoil_intensity)
	else:
		print("لا توجد ذخيرة في سلاح %s" % weapon.name)

func switch_weapon(weapon_name: String):
	if weapon_name in arsenal:
		current_weapon = weapon_name
		print("تم التبديل إلى سلاح %s" % weapon_name)

func reload():
	if current_weapon in arsenal:
		var weapon = arsenal[current_weapon]
		weapon.ammo = weapon.max_ammo
		print("تمت إعادة تعبئة سلاح %s" % weapon.name)
		if OS.get_name() == "Android":
			OS.vibrate_handheld(50)

func get_current_weapon_status() -> String:
	if current_weapon in arsenal:
		var weapon = arsenal[current_weapon]
		return "السلاح الحالي: %s - الذخيرة: %d/%d" % [weapon.name, weapon.ammo, weapon.max_ammo]
	return "لا يوجد سلاح"

func _process(delta):
	pass
