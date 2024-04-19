extends CanvasLayer
class_name PlayerUI

@export_category("Data Resources")
@export var player : Player
#@export var inventory : InventoryResource
@export var invmanager : InventoryManager


@export_category("Children")
@export var PauseMenu : PauseMenuController
@export var HealthBar : ProgressBar
@export var AttackIndex : AttackBarController
@export var StaminaIndicatorBox : IndicatorBox
@export var AnxMeter : Label
@export var CoinLabel : Label
@export var PowderGUI : ItemGUI
@export var ElixirGUI : ItemGUI
@export var StatueMenu : Statue_Menu
@export var Shop : ShopMenu
@export var XP : XPTracker

#var iniinv : InventoryItem

func _ready():
	player = get_parent()
	HealthBar.max_value = player.MaxHealth
	XP.AddAmount.visible = false

func _process(_delta):
	HealthBar.value = player.CurrentHealth
	
	CoinLabel.text = ("$" + str(invmanager.InventoryData.CoinAmount))	
	#print("ths is iniinv " + str(iniinv.Name))
		
	if invmanager.InventoryData.Elixirs > 0 :
		if invmanager.InventoryData.ElixerEquiped == invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Lite Elixir"]:
			
		#if (inventory.InventoyMap[InventoryItem.eItemTypes.Elixir]["Lite Elixir"]).AmountHeld > 0:
			ElixirGUI.DisplayItem(invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Lite Elixir"])
		if invmanager.InventoryData.ElixerEquiped == invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Mild Elixir"]:
		#else:
			ElixirGUI.DisplayItem(invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Elixir]["Mild Elixir"])
					
	else:
		ElixirGUI.visible = false
		
	if invmanager.InventoryData.Powders > 0 :
		if invmanager.InventoryData.PowerEquiped == invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder]["Azalea Powder"]:
			PowderGUI.DisplayItem(invmanager.InventoryData.InventoryStorage[InventoryItem.eItemTypes.Powder]["Azalea Powder"])
	else:
		PowderGUI.visible = false
	#
	if invmanager.InventoryData.CurrentItem != null:
		match invmanager.InventoryData.CurrentItem.ItemType:
			InventoryItem.eItemTypes.Elixir:
				ElixirGUI.Border.visible = true
				PowderGUI.Border.visible = false
		
			InventoryItem.eItemTypes.Powder:
				PowderGUI.Border.visible = true
				ElixirGUI.Border.visible = false
	#
	var eTimeInMinutes = player.GM.ElapsedTime / 60
	var eTimeSeconds = fmod(player.GM.ElapsedTime, 60)
	AnxMeter.text = "Elapsed Time: " + "%02d:%02d" % [eTimeInMinutes, eTimeSeconds]
	
	XP.ResolvePoints.text = str(player.ResolvePoints)
	XP.Amount.text = str(player.CurrentXP)
	XP.AmountAdding = player.GM.StockpiledXP
	XP.AddAmount.text = "+" + str(XP.AmountAdding)
	XP.Bar.value = player.CurrentXP
	XP.Bar.max_value = player.NeededXP
	
	AttackIndex.value = player.AttackTimer.time_left
	
	if player.AttackTimer.time_left > 0:
		AttackIndex.Particles.emitting = true
	else:
		AttackIndex.Particles.emitting = false
	
	'if player.AttackTimer.time_left > 0:
		AttackIndex.Particles.emitting = true
		AttackIndex.Particles.position = lerp(AttackIndex.Particles.position, Vector2(0, 10), player.AttackTime * _delta)
	else:
		AttackIndex.Particles.emitting = false
		if AttackIndex.Particles.position != AttackIndex.pStartingPos:
			AttackIndex.Particles.position = AttackIndex.pStartingPos'
	
	if GameSettings.ShouldFillAnxiety == true:
		$"Main UI/AnxietyMeter".visible = true
	else:
		$"Main UI/AnxietyMeter".visible = false
		
	if Input.is_action_just_pressed("Pause"):
		if PauseMenu.visible == false && player.CurrentState == player.eStates.InMenu:
			return
		else:
			TogglePauseMenu()
		
	if PauseMenu.visible:
		player.CurrentState = player.eStates.InMenu
		
func SetStaminaIcons(Amount : int):
	for i in StaminaIndicatorBox.get_child_count():
		StaminaIndicatorBox.get_child(i).queue_free()
	
	for i in Amount:
		var newIcon = StaminaIndicatorBox.Icon.instantiate()
		StaminaIndicatorBox.add_child(newIcon)

func UpdateStaminaIcons(Amount : int):
	var icons = StaminaIndicatorBox.get_children()
	
	for i in icons.size():
		if i > Amount - 1:
			icons[i].IsFilled = false
			
func RefillStaminaIcons(Amount : int):
	for i in Amount:
		if StaminaIndicatorBox.get_child(i).IsFilled == false:
			StaminaIndicatorBox.get_child(i).IsFilled = true

func TogglePauseMenu():
	var MenuTween = get_tree().create_tween()
	MenuTween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	if !PauseMenu.visible:
		#print("Opening Pause Menu...")
		PauseMenu.StartMusic()
		PauseMenu.visible = true
		MenuTween.tween_property(PauseMenu, "size", Vector2(PauseMenu.xMax, PauseMenu.yMax), 0.25)
		await MenuTween.finished
		PauseMenu.EnableChildren()
		PauseMenu.DrawLocationName(player.GM.Level.AreaName)
		get_tree().paused = true
	else:
		#print("Closing Pause Menu...")
		PauseMenu.StopMusic()
		PauseMenu.DisableChildren()
		MenuTween.tween_property(PauseMenu, "size", Vector2(0, PauseMenu.yMax), 0.25)
		await MenuTween.finished
		player.CurrentState = player.eStates.NoAction
		PauseMenu.DeleteName()
		PauseMenu.visible = false
		get_tree().paused = false

func ToggleMenu(Menu : Object, Choice : bool):
	Menu.visible = Choice
	if Choice == true:
		player.CurrentState = player.eStates.InMenu
	else:
		player.CurrentState = player.eStates.NoAction
		
func DisplayAttackIndex(time : float, index : int, cooldown : bool):
	AttackIndex.max_value = time
	#AttackIndex.Particles.position = AttackIndex.pStartingPos
	AttackIndex.Particles.emitting = true
	
	if cooldown:
		AttackIndex.IndexLabel.text = "Cooldown!"
	
	else:
		match index:
			2:
				AttackIndex.IndexLabel.text = "I"
			3:
				AttackIndex.IndexLabel.text = "II"
			4:
				AttackIndex.IndexLabel.text = "III"
	
	#AttackIndex.Particles.position = AttackIndex.pStartingPos
	#AttackIndex.Particles.position = lerp(AttackIndex.Particles.position, Vector2(0, 10), player.AttackTime * get_process_delta_time())
	#var pTween = get_tree().create_tween()
	#pTween.tween_property(AttackIndex.Particles, "position", Vector2(0, 25), time - 0.25)
	#await pTween.finished
	#AttackIndex.Particles.emitting = false

func PlayXPTransfer(pitch : float):
	XP.SFX.pitch_scale = pitch
	XP.SFX.stream = XP.XpTrack
	XP.SFX.play()

func PlayRPGain():
	XP.SFX.stream = XP.RpTrack
	XP.SFX.pitch_scale = 1.0
	XP.SFX.play()

func PlayCollapseTrack():
	XP.SFX.pitch_scale = 1.0
	var RNG = RandomNumberGenerator.new()
	#var newPoint = RNG.randf_range(0.1, XP.CollapseTrack.get_length())
	XP.SFX.stream = XP.CollapseTrack
	XP.SFX.play()
	
func CutXPAudio():
	XP.SFX.stop()
