
import hxvlc.flixel.FlxVideoSprite;
import funkin.menus.MainMenuState;

var intro:FlxVideoSprite;

function create() {
    add(intro = new FlxVideoSprite(320, 153)).load(Assets.getPath(Paths.file('videos/intro.mkv')));
    intro.scale.set(2.6, 2.6);
    intro.antialiasing = false;
    intro.play();

    new FlxTimer().start(2.9, () -> {
        FlxG.switchState(new MainMenuState());
    });
}