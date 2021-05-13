extends Control

export(String) var stage_top_left
export(String) var stage_top_center
export(String) var stage_top_right
export(String) var stage_mid_left
export(String) var stage_mid_right
export(String) var stage_bottom_left
export(String) var stage_bottom_center
export(String) var stage_bottom_right

var _buttons: Array

func _ready() -> void:
    $FadeEffects.margin_left = -Global.get_base_size().x
    $FadeEffects.margin_top = -Global.get_base_size().x
    $FadeEffects.margin_right = Global.get_base_size().x
    $FadeEffects.margin_bottom = Global.get_base_size().x
    $FadeEffects.fade_in(0.5)
    yield($FadeEffects, "screen_faded_in")
    $"Buttons/ButtonMidCenter".grab_focus()
    $"Background/ShopButton".play()

    if not OS.is_debug_build():
        $Music.play()
    
    var index: int = 0
    for button in $Buttons.get_children():
        _buttons.append(button)
        button.connect("focus_entered", self, "_on_focus_entered", [index])
        button.connect("pressed", self, "_on_pressed", [index])
        index += 1

func _on_focus_entered(index: int) -> void:
    $MoveCursorSound.play()
    $"Mugshots/MugshotMidCenter".frame = index

func _on_pressed(index: int) -> void:
    var path: String
    match index:
        0:
            path = stage_top_left
        1:
            path = stage_top_center
        2:
            path = stage_top_right
        3:
            path = stage_mid_left
        5:
            path = stage_mid_right
        6:
            path = stage_bottom_left
        7:
            path = stage_bottom_center
        8:
            path = stage_bottom_right

    if path.empty():
        return

    for button in _buttons:
        button.disabled = true
        if button != _buttons[index]:
            # Setting buttons to invisible will stop them
            # from being able to receive focus. Workaround for missing
            # possiblity to stop receiving input events for control nodes.
            button.visible = false
    $FlashEffect.play("flash")
    $Music.stop()
    $StageSelectedSound.play()
    yield($StageSelectedSound, "finished")
    $FadeEffects.fade_out(0.5)
    yield($FadeEffects, "screen_faded_out")
    Global.main_scene.switch_scene(path)
