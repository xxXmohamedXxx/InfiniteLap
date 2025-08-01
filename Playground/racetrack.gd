extends Node2D
var lap = 1

func change_lap():
	lap +=1
	print(lap)
	#for child in get_children():
	#	if child.name == String(lap):
	#		print("node activated")
	#	elif child.name == String(lap - 1):
	#		print("node deactivated")
