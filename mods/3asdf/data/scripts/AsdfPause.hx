
import flixel.text.FlxTextBorderStyle;
import flixel.text.FlxText.FlxTextAlign;
import flixel.group.FlxGroup.FlxTypedGroup;

var pauseCam = new FlxCamera();

var bg:FlxSprite;
var guy:FlxSprite;
var muffin:FlxSprite;
var textBg:FlxSprite;

var options:Array<String> = [
    'Resume',
    'Restart',
    'Controls',
    'Options',
    'Quit'
];

var txtGroup:FlxTypedGroup<FlxText>;

function create(_) {
    _.cancel(); // cancels base pause menu
    cameras = [];

    FlxG.cameras.add(pauseCam, false).bgColor = 0;
 
    add(bg = new FlxSprite().makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK)).alpha = 0;
    FlxTween.tween(bg, {alpha: 0.55}, 0.5, {ease: FlxEase.circOut});

    add(guy = new FlxSprite(-280, -290).loadGraphic(Paths.image('pause/guy'))).scale.set(0.37, 0.37);
    add(muffin = new FlxSprite(140, 220).loadGraphic(Paths.image('pause/muffin'))).scale.set(0.37, 0.37);

    FlxTween.cancelTweensOf(guy); 
    FlxTween.cancelTweensOf(muffin);

    FlxTween.tween(guy, {x: -240}, 0.55, {ease: FlxEase.circOut});
    FlxTween.tween(muffin, {y: 140}, 0.55, {ease: FlxEase.circOut});

    add(textBg = new FlxSprite().makeSolid(FlxG.width / 4, FlxG.height - 100, FlxColor.BLACK)).screenCenter(FlxAxes.Y);
    textBg.alpha = 0;
    FlxTween.tween(textBg, {alpha: 0.7}, 0.5, {ease: FlxEase.circOut});

    add(txtGroup = new FlxTypedGroup(8));

    for (i in 0...menuItems.length) {
        var text:FlxText = new FlxText(0, 100 + (i * 120), 0, options[i]);
        text.setFormat(Paths.font('arial.ttf'), 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.NONE);
        text.centerOrigin();
        text.screenCenter(FlxAxes.X);
        text.x += FlxG.width / 5;
        textBg.x = text.getGraphicMidpoint().x - textBg.scale.x / 2;
        text.antialiasing = true;
        text.ID = i;
        txtGroup.add(text);
    }

    changeSelection(0);

    cameras = [pauseCam];
}

function update() {
    if (controls.UP_P || controls.DOWN_P) {
        changeSelection(controls.UP_P ? -1 : 1);
        FlxG.sound.play(Paths.sound('menu/scroll'));
    }

    if (controls.ACCEPT) selectOption();
}

function changeSelection(change) {
	curSelected += change;

	if (curSelected < 0) curSelected = menuItems.length - 1;
	if (curSelected >= menuItems.length) curSelected = 0;

    txtGroup.forEach(function(txt:FlxText) { 
        txt.scale.x = txt.scale.y = (txt.ID == curSelected) ? 1.2 : 1;
        //if (txt.ID == curSelected) txt.centerOrigin();
    });
}
