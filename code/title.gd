extends Node2D


func _on_lvl_1_button_up() -> void:
	Global.switchScene("res://scenes/levels/tester0.tscn")


func _on_lvl_2_button_up() -> void:
	Global.switchScene("res://scenes/levels/tester_1.tscn")
	
func _on_lvl_3_button_up() -> void:
	Global.switchScene("res://scenes/levels/tester_2.tscn")
