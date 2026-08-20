import flixel.text.FlxTextBorderStyle;
import Sys;
import funkin.backend.utils.DiscordUtil;

var clock:FlxSprite;
var arm:FlxSprite;
var mango:FlxSprite;
var camOther:FlxCamera;
var good:FlxSprite;
var good2:FlxSprite;
var lol:Array<Int> = [-1, -1];
var lol2:Array<Int> = [1, 1];
var speed = 600;

function create(){
    var white:FlxSprite = new FlxSprite(0, 0).makeSolid(FlxG.width * 2, FlxG.height * 2, FlxColor.WHITE);
    white.screenCenter();
    white.scrollFactor.set();
    insert(0, white);

    updateDiscordPresence = function() {
        DiscordUtil.changeSongPresence(PlayState.detailsText, '????', PlayState.instance.inst, getIconRPC());
    };
}

function postCreate(){
    FlxG.cameras.add(camOther = new FlxCamera(), false).bgColor = 0;

    mango = new FlxSprite(0, 0).loadGraphic(Paths.image('BOIIIphonk'));
    mango.cameras = [camOther];
    insert(0, mango);
    mango.scale.set(2.7, 1.39);
    mango.screenCenter();
    mango.alpha = 0.0001;

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

    for (h in [healthBar,healthBarBG,iconP1,iconP2,scoreTxt,accuracyTxt,missesTxt]) remove(h);

    canDie = false;

    good = new FlxSprite(0, 0).loadGraphic(Paths.image('ganoli1'));
    good.screenCenter();
    insert(50, good);
    good.cameras = [camHUD];
    good.scale.set(0.8, 0.8);
    good.updateHitbox();

    good2 = new FlxSprite(1280, 720).loadGraphic(Paths.image('ganoli2'));
    good2.screenCenter();
    insert(50, good2);
    good2.cameras = [camHUD];
    good2.scale.set(0.8, 0.8);
    good2.updateHitbox();
}

function postUpdate(){
    arm.angle = (Conductor.songPosition / inst.length) * 60000;

    good.velocity.x = speed * lol[0];
    good.velocity.y = speed * lol[1];

    if (good.x >= (1280 - good.width)) lol[0] = -1;
    if (good.x <= 0) lol[0] = 1;

    if (good.y >= (720 - good.height)) lol[1] = -1;
    if (good.y <= 0) lol[1] = 1;


    good2.velocity.x = speed * lol2[0];
    good2.velocity.y = speed * lol2[1];

    if (good2.x >= (1280 - good2.width)) lol2[0] = -1;
    if (good2.x <= 0) lol2[0] = 1;

    if (good2.y >= (720 - good2.height)) lol2[1] = -1;
    if (good2.y <= 0) lol2[1] = 1;

    if (FlxG.keys.justPressed.B) player.cpu = !player.cpu;
}

function stepHit(curStep){
    switch(curStep){
        case 295: mango.alpha = 1;
        case 296: Sys.exit();
    }
}