extends Node
class_name CraftingSystem

# نظام التصنيع والموارد (Crafting & Resources System)
# يسمح للاعب بصناعة وتطوير الدبابات والطائرات والمدرعات

class Vehicle:
	var name: String
	var iron_cost: int
	var fuel_cost: int
	var armor: int
	
	func _init(p_name: String, p_iron: int, p_fuel: int, p_armor: int):
		name = p_name
		iron_cost = p_iron
		fuel_cost = p_fuel
		armor = p_armor

var resources: Dictionary = {
	"حديد": 0,
	"وقود": 0,
	"ذخيرة": 0
}

var vehicles: Dictionary = {}

func _ready():
	# إضافة مركبات حقيقية (دبابة الفهد، مدرعة النمر)
	vehicles["دبابة الفهد"] = Vehicle("دبابة الفهد", 100, 50, 200)
	vehicles["مدرعة النمر"] = Vehicle("مدرعة النمر", 50, 30, 100)

# جمع الموارد من ساحة المعركة
func collect_resource(resource_name: String, amount: int):
	if resource_name in resources:
		resources[resource_name] += amount
		var total = resources[resource_name]
		print("تم جمع %d من %s. المجموع الآن: %d" % [amount, resource_name, total])

# صناعة مركبة جديدة
func craft_vehicle(vehicle_type: String):
	if vehicle_type not in vehicles:
		return
	
	var vehicle = vehicles[vehicle_type]
	
	if resources["حديد"] >= vehicle.iron_cost and resources["وقول"] >= vehicle.fuel_cost:
		resources["حديد"] -= vehicle.iron_cost
		resources["وقود"] -= vehicle.fuel_cost
		print("تمت صناعة %s بنجاح. استعد للقيادة." % vehicle.name)
	else:
		print("لا توجد موارد كافية لصناعة %s. تحتاج إلى المزيد من الحديد والوقود." % vehicle.name)

# التحقق من الموارد المتاحة
func check_resources() -> String:
	var status = "الموارد المتاحة: "
	for resource_name in resources:
		status += "%s: %d، " % [resource_name, resources[resource_name]]
	return status

func get_resources() -> Dictionary:
	return resources.duplicate()

func _process(delta):
	pass
