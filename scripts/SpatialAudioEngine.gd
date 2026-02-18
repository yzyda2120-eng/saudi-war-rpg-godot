extends Node
class_name SpatialAudioEngine

# محرك الصوت المحيطي (3D Spatial Audio Engine)
# يمثل "عين" اللاعب المكفوف بدقة 360 درجة

var audio_player: AudioStreamPlayer3D
var sounds: Dictionary = {}

func _ready():
	audio_player = AudioStreamPlayer3D.new()
	add_child(audio_player)
	audio_player.bus = "Master"

# تشغيل صوت في موقع محدد بالنسبة للاعب
# azimuth: الزاوية الأفقية (0-360 درجة)
# distance: المسافة (0.0 إلى 1.0)
func play_spatial_sound(sound_name: String, azimuth: float, distance: float):
	if sound_name not in sounds:
		return
	
	# حساب موقع الصوت في الفضاء ثلاثي الأبعاد
	var angle_rad = deg2rad(azimuth)
	var x = cos(angle_rad) * distance * 10.0
	var z = sin(angle_rad) * distance * 10.0
	
	audio_player.global_transform.origin = Vector3(x, 0, z)
	audio_player.stream = sounds[sound_name]
	audio_player.play()
	
	# إخبار اللاعب بموقع الصوت صوتياً
	var direction = ""
	if azimuth < 45 or azimuth > 315:
		direction = "أمامك"
	elif azimuth >= 45 and azimuth < 135:
		direction = "يمينك"
	elif azimuth >= 135 and azimuth < 225:
		direction = "خلفك"
	elif azimuth >= 225 and azimuth < 315:
		direction = "يسارك"
	
	var distance_text = "قريب جداً" if distance > 0.7 else "بعيد" if distance < 0.3 else "متوسط"
	print("صوت %s من %s - %s" % [sound_name, direction, distance_text])

func load_sound(name: String, path: String):
	var audio_stream = load(path)
	if audio_stream:
		sounds[name] = audio_stream

func _process(delta):
	pass
