extends Node2D


func _on_lvl_1_button_up() -> void:
	Global.switchScene("res://scenes/levels/v_2_lvl_1.tscn")


func _on_lvl_2_button_up() -> void:
	Global.switchScene("res://scenes/levels/V2Lvl2.tscn")
	
func _on_lvl_3_button_up() -> void:
	Global.switchScene("res://scenes/levels/v_2_lvl_3.tscn")
