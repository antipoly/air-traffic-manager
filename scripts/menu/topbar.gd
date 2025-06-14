extends PanelContainer

@onready var title_screen = %TitleScreen;
@onready var game_title = $MC/HBC/Title;
@onready var current_menu = $MC/HBC/CurrentMenu;
@onready var player_info = $MC/HBC/PlayerInfo;
@onready var player_name = $MC/HBC/PlayerInfo/Name;
@onready var facility_level = $MC/HBC/PlayerInfo/FacilityLevel

signal current_menu_pressed()

func _ready() -> void:
  title_screen.connect("menu_changed", Callable(self, "_on_menu_changed"));

func _on_menu_changed(menu_name: String) -> void:
  var tween = game_title.create_tween().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT);
  tween.tween_property(game_title, "position:x", 0.0, 0.5);

  current_menu.modulate = Color(1, 1, 1, 0);
  current_menu.show();
  
  await tween.finished;

  var player = ResourceManager.get_player();
  var spec = ResourceManager.get_specialisation();
  var level = ResourceManager.get_player_level();

  current_menu.text = menu_name;
  game_title.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN | Control.SIZE_EXPAND;
  player_name.text = "%s | %s %s" % [player.player_name, spec.acr, level.name];
  facility_level.text = "Facility Level %d" % player.facility_level;


  player_info.modulate = Color(1, 1, 1, 0);
  player_info.show();

  Utils.fade_alpha(current_menu, "in", 1.0);
  Utils.fade_alpha(player_info, "in", 1.0);


func _on_current_menu_pressed() -> void:
  emit_signal("current_menu_pressed");
