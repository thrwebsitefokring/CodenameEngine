
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextAlign;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.savedata.FunkinSave;

import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import funkin.menus.FreeplayState;
import funkin.menus.credits.CreditsMain;
import funkin.options.OptionsMenu;
import flixel.input.keyboard.FlxKey;
import funkin.backend.utils.DiscordUtil;

var txtGroup;

var options:Array<String> = [
    'play',
    'options',
    'credits'
];

var select;
var curSelected = 0;

public var typin:String = '';

function create() {
    add(txtGroup = new FlxTypedGroup(4));

    for (i in 0...options.length) {
        var text:FlxText = new FlxText(0, 170 + (i * 150), 0, options[i]);
        text.setFormat(Paths.font('arial.ttf'), 50, FlxColor.BLACK, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
        text.screenCenter(FlxAxes.X);
        text.antialiasing = true;
        txtGroup.add(text);
    }

    add(select = new FlxSprite(440).loadGraphic(Paths.image('menuTriangle')));

    CoolUtil.playMenuSong();
    FlxG.camera.bgColor = FlxColor.WHITE;

    DiscordUtil.changePresence("...", null);
}

function update(elapsed) {
    if (FlxG.keys.firstJustPressed() != FlxKey.NONE) codePress(FlxG.keys.firstJustPressed());

    if (controls.UP_P || controls.DOWN_P) {
        curSelected += controls.UP_P ? -1 : 1;
        FlxG.sound.play(Paths.sound('menu/scroll'), 0.5);
    }

    if (curSelected < 0) curSelected = options.length-1;
    if (curSelected > options.length-1) curSelected = 0;

    select.y = txtGroup.members[curSelected].y + 10;

    if (controls.ACCEPT) {
        FlxG.switchState(switch (curSelected) {
            case 0: new ModState('Comic'); // tehy wanted it to play EVERY TIME
            case 1: new OptionsMenu();
            case 2: new ModState('credits');
        });
    }

    if (controls.SWITCHMOD || FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = false; 
        persistentDraw = true;

        openSubState(controls.SWITCHMOD ? new ModSwitchMenu() : new EditorPicker());
    }
}

function codePress(pressedKey:FlxKey) {
    var daKey = CoolUtil.keyToString(pressedKey).toUpperCase();
    var allowedShit = "GANOLI";

    if (allowedShit.indexOf(daKey) == -1) {
        typin = '';
        return;
    }

    typin += daKey;

    switch (typin) {
        case "GANOLI":
            PlayState.loadSong("GANOLI", "hard");
            FlxG.switchState(new PlayState());
    }
}
