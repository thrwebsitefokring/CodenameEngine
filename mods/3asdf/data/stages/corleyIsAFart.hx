
import flixel.text.FlxTextBorderStyle;
import openfl.system.Capabilities;
import flixel.text.FlxTextBorderStyle;
import funkin.backend.utils.DiscordUtil;

public var asdf_bg;
public var head;
public var eyes;
public var tomno;
public var evilbg = [];

public var scoreStuff;
public var clock;
public var arm;
public var hudShit = [];

public var camMove = false;
public var camSnap = false;
public var camPos = [110, 30];

public var eyemove = false;
public var muffinCamZoom = false;
var stupid = false;

public var camOther;

var lastFocused:Int = null;

var healthPoop;
var accuracyPoop;

public var guyZoom = 0.8;
public var muffinZoom = 1;

function create(){
    updateDiscordPresence = function() {
        DiscordUtil.changeSongPresence(PlayState.detailsText, (PlayState.instance.paused ? "PAUSED - " : "") + 'DIE', PlayState.instance.inst, getIconRPC());
    };
}

function postCreate() {
    canDie = false;
    
    insert(0, tomno = new FlxSprite(230, 180).loadGraphic(Paths.image('tomno'))).cameras = [camHUD];
    tomno.frames = Paths.getFrames('tomno');
    tomno.animation.addByPrefix('idle', 'nope', 20);
    tomno.animation.play('idle');
    tomno.alpha = 0;
    tomno.scale.set(0.8, 0.8);
    tomno.screenCenter();

    FlxG.camera.bgColor = FlxColor.WHITE;

    insert(0, asdf_bg = new FlxSprite(-700, -400).loadGraphic(Paths.image('stages/corleyIsAFart/asdf_bg'))).scale.set(1.6, 1.3);
    asdf_bg.flipY = true;
    asdf_bg.visible = false;

    insert(1, eyes = new FlxSprite(150, -1000).loadGraphic(Paths.image('stages/corleyIsAFart/tomeyes'))).scale.set(0.8, 0.8);
    insert(2, head = new FlxSprite(150, -1000).loadGraphic(Paths.image('stages/corleyIsAFart/tomhead'))).scale.set(0.8, 0.8);

    evilbg = [sky, train, wagon, debris1, gradient, ground, rocksfg, backk];
    for (s in evilbg) s.alpha = eyes.alpha = head.alpha = 0.0001;

    FlxG.cameras.add(camOther = new FlxCamera(), false).bgColor = 0;

    add(scoreStuff = new FlxText(0, 650, 0)).cameras = [camHUD];
    scoreStuff.setFormat(Paths.font('arial.ttf'), scoreTxt.size * 2.8, FlxColor.BLACK, 'none', FlxTextBorderStyle.NONE);
    scoreStuff.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.WHITE, 2, 1);
    scoreStuff.antialiasing = true;
    scoreStuff.screenCenter(FlxAxes.X);
 
    add(clock = new FlxSprite(0, 30).loadGraphic(Paths.image('clock')));
    add(arm = new FlxSprite().loadGraphic(Paths.image('arm')));

    for (i => c in [clock, arm]) {
        c.scale.set(0.5 - i/10, 0.5 - i/10);
        c.updateHitbox();
        c.screenCenter(FlxAxes.X);
    }

    // the arm took forever to offset kms
    arm.origin.y = 120;
    arm.y = clock.y - arm.height / 4;
    if (camHUD.downscroll) arm.y += 114;

    for (l in [clock, arm]) l.cameras = [camHUD];
    hudShit = [arm, clock, scoreStuff];

    for (h in [healthBar,healthBarBG,iconP1,iconP2,scoreTxt,accuracyTxt,missesTxt]) remove(h);
    enabled = true;

    PauseSubState.script = 'data/scripts/AsdfPause';
    allowGitaroo = false;
}

function postUpdate() {
    if (stupid && health <= 0.1) {
        FlxTween.cancelTweensOf(tomno);
        tomno.alpha = 1;
        FlxTween.tween(tomno, {alpha: 0}, 2, {ease: FlxEase.quadInOut});
        stupid = false;
    } else if (health > 0.1) {
        stupid = true;
    } else if (health <= 0.1) {
        health = 0.1;
    }

    head.angle = FlxG.random.float(-1, 1);
    eyes.offset.set(FlxG.random.float(-1, 1), FlxG.random.float(-1, 1));

    if (health * 50 <= 100) healthPoop = 'Health: ' + FlxMath.roundDecimal(health * 50, 0) + '%     ';
    if (accuracy > 0) accuracyPoop = '     Accuracy: ' + FlxMath.roundDecimal(accuracy * 100, 2) + '%';
    else accuracyPoop = '     Accuracy: N/A';

    scoreStuff.text = healthPoop + 'Misses: ' + misses + accuracyPoop;
    scoreStuff.screenCenter(FlxAxes.X);

    arm.angle = (Conductor.songPosition / inst.length) * 360;

    if (!camMove) camFollow.setPosition(camPos[0], camPos[1]);
    if (camSnap) FlxG.camera.snapToTarget();

    if (eyemove){
        head.y = Math.sin(Conductor.songPosition / 200) * 15 - 490;
        eyes.y = Math.sin(Conductor.songPosition / 200) * 15 - 487;
    }
}

function onCameraMove(_) { if (lastFocused != (lastFocused = curCameraTarget)) 
    if (eyemove) {
        var c = (lastFocused == 0);

        FlxTween.cancelTweensOf(eyes); // juust in case
        FlxTween.tween(eyes, {x: (c ? 140 : 160), y: (c ? -496 : -497)}, 1, {ease: FlxEase.cubeInOut});
    }
    if (muffinCamZoom) defaultCamZoom = (curCameraTarget == 0 ? guyZoom : muffinZoom);
}

introLength = 0;
function onCountdown(_) _.cancel();
function destroy() FlxG.camera.bgColor = FlxColor.BLACK;
