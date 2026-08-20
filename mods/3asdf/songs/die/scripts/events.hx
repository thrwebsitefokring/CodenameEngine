
import hxvlc.flixel.FlxVideoSprite;
import openfl.geom.ColorTransform;

var noFuckingCamZooming, floatItems = false;
var black = new FlxSprite().makeSolid(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);

var intro, cutscene;
var ending = 'bad';
var videos = [];
var tomHead:FlxSprite;
var tomEyes:FlxSprite;

public var playerStrumsDefaultX:Array<Int> = [0, 0, 0, 0];
public var playerStrumsDefaultY:Array<Int> = [0, 0, 0, 0];

public var cpuStrumsDefaultX:Array<Int> = [0, 0, 0, 0];
public var cpuStrumsDefaultY:Array<Int> = [0, 0, 0, 0];

function postCreate() {
    tomHead = new FlxSprite(-1500, -1400);
    tomHead.frames = Paths.getSparrowAtlas('stages/corleyIsAFart/tomska');
    tomHead.animation.addByPrefix('idle', 'tomska idle', 6, true);
    tomHead.animation.play('idle');
    add(tomHead);
    tomHead.alpha = 0.0001;

    tomEyes = new FlxSprite(-400, -650).loadGraphic(Paths.image('stages/corleyIsAFart/evilEyes'));
    insert(members.indexOf(tomHead)-1,tomEyes);
    tomEyes.alpha = 0.0001;

    black.alpha = 0.0001;
    black.scrollFactor.set();
    black.screenCenter();
    add(black);

    camGame.visible = camHUD.visible = false;

    // precaches videos
    for (i => v in ['songIntro','bad','good']) vv = new FlxVideoSprite().load(Assets.getPath(Paths.file('videos/' + v + '.mkv'))); 

    dad.colorTransform = new ColorTransform();
    boyfriend.colorTransform = new ColorTransform();

    comboGroup.visible = false;
    strumLines.members[1].characters[1].alpha = 0.0001;

    add(intro = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/songIntro.mkv')));
    intro.scale.set(0.7, 0.7);
    intro.setPosition(-340, -190);
    intro.cameras = [camOther];
    intro.updateHitbox();
    intro.play();
    videos.push(intro);

    intro.alpha = 0;
    FlxTween.tween(intro, {alpha: 1}, 1);

    for (i in 0...4){
        playerStrumsDefaultX[i] = playerStrums.members[i].x;

        playerStrumsDefaultY[i] = playerStrums.members[i].y;

        cpuStrumsDefaultX[i] = cpuStrums.members[i].x;

        cpuStrumsDefaultY[i] = cpuStrums.members[i].y;
    }
}

function stepHit(s) {
    // for more accurate shit
    switch(s) {
        case 155:
            remove(intro, true);
        case 1394:
            for (a in hudShit) a.alpha = 0.001;
            for (a in playerStrums) a.alpha = 0.001;
            cpuStrums.visible = false;
            
            ending = (accuracy >= 0.8) ? 'good' : 'bad';

            insert(1, cutscene = new FlxVideoSprite()).load(Assets.getPath(Paths.file('videos/' + ending + '.mkv')));
            cutscene.cameras = [camHUD];
            cutscene.updateHitbox();
            cutscene.play();
            videos.push(cutscene);

            camHUD.alpha = 1;
            camZooming = false;
            noFuckingCamZooming = true;

        case 2304:
            camHUD.flash(FlxColor.RED);
            guyZoom = muffinZoom = 0.8;
            eyes.visible = head.visible = muffinCamZoom = false;
      
            if (ending == 'good') {
                insert(0, pic = new FlxSprite().loadGraphic(Paths.image('goodEndingPic'))).scale.set(0.65, 0.65);
                pic.cameras = [camHUD];
                pic.screenCenter();
            
                camGame.stopFade();
                camGame.fade(FlxColor.BLACK, 38, false);
            } else {
                executeEvent({name: 'Change Character', params: [0, 'realphase1', 0 , false]});
                executeEvent({name: 'Change Character', params: [1, 'muffinphase1', 0, false]});  
                dad.colorTransform.color = boyfriend.colorTransform.color = 0xFFFFFFFF;
                dad.color = boyfriend.color = 0xFF000000;
                for (a in strumLines) {
                    for(b in a){
                        updateStrumSkin(b, "default", b.ID);
                        b.y = a.startingPos.y;
                    }
                    for(c in a.notes)
                        updateNoteSkin(c, "default");
                }
                for (i in 0...4){
                    playerStrums.members[i].x = playerStrumsDefaultX[i];
                    playerStrums.members[i].y = playerStrumsDefaultY[i];
                
                    cpuStrums.members[i].x = cpuStrumsDefaultX[i];
                    cpuStrums.members[i].y = cpuStrumsDefaultY[i];
                }
            }
            camZoomingInterval = 4;
            for (a in evilbg) a.alpha = 0.0001;
            tomEyes.alpha = tomHead.alpha = 0.0001;
    }
}

function beatHit(_) {
    switch (_) {
        case 40:
            defaultCamZoom = 0.8;
            camGame.visible = camHUD.visible = camMove = true;
            camHUD.flash();
        case 131:
            FlxG.camera.followLerp = 0;
            FlxTween.tween(camGame.scroll, {x: -850}, 2.4, {ease: FlxEase.expoInOut});
            FlxTween.tween(camGame, {zoom: 0.9}, 2.4, {ease: FlxEase.expoInOut});
        case 136:
            FlxTween.completeTweensOf(camGame.scroll);
            FlxTween.cancelTweensOf(camGame);
            FlxTween.tween(camGame.scroll, {x: -480, y: -330}, 0.001);
          
            defaultCamZoom = camGame.zoom = FlxG.camera.zoom = 1;
            camGame.flash(FlxColor.BLACK, 0.5);
            flick(camGame, 0.01, 0.08, 15);
            asdf_bg.visible = true;

            eyes.alpha = head.alpha = 1;

            FlxTween.tween(eyes, {x: 160, y: -497}, 2, {ease: FlxEase.cubeOut});
            FlxTween.tween(head, {y: -500}, 2, {ease: FlxEase.cubeOut, onComplete: function() {
                eyemove = true;
                realeyemove = true;
            }});

        case 142:
            FlxG.camera.followLerp = 0.04;
        
        case 196:
            FlxG.camera.followLerp = 0;
            FlxTween.tween(camGame.scroll, {x: -100, y: -140}, 2.65, {ease: FlxEase.expoInOut});
            FlxTween.tween(camGame, {zoom: 1.5}, 2.5, {ease: FlxEase.expoInOut});

        case 200:
            for (a in strumLines) {
                for(b in a){
                    updateStrumSkin(b, "NOTE_assets_Aethos", b.ID);
                    b.y = a.startingPos.y;
                }
                for(c in a.notes)
                    updateNoteSkin(c, "NOTE_assets_Aethos");
            }
            playerStrums.members[0].x -= 12;
            playerStrums.members[0].y += 2;
            cpuStrums.members[0].x -= 12;
            cpuStrums.members[0].y += 2;
            FlxTween.cancelTweensOf(camGame);
            FlxTween.cancelTweensOf(camGame.scroll);
            FlxG.camera.followLerp = 0.04;
            camHUD.flash(FlxColor.RED, 0.6);
            FlxG.camera.bgColor = 0;
            for (s in evilbg) s.alpha = 1;
            tomEyes.alpha = tomHead.alpha = 1;
            asdf_bg.destroy();
            floatItems = true;
            defaultCamZoom -= 0.6;
            muffinCamZoom = true;
            guyZoom = 0.4;
            muffinZoom = 0.55;
        case 312:
            FlxTween.tween(camGame, {zoom: 0.8}, 6, {ease: FlxEase.cubeIn});
        case 328:
            camGame.alpha = camHUD.alpha = 0.001;
        case 396:
            for (a in playerStrums) FlxTween.tween(a, {alpha: 1}, 1.5);
        case 432:
            remove(cutscene, true);
            cpuStrums.visible = true;
            for (a in hudShit) a.alpha = 1;
            camGame.alpha = 1;
            muffinZoom = camGame.zoom = 1.2;
            camGame.flash(FlxColor.RED);
            camZooming = true;
            noFuckingCamZooming = false;
            if (ending == 'good'){
                strumLines.members[1].characters[0].alpha = 0.001;
                strumLines.members[1].characters[1].alpha = 1;
            }
            boyfriend.cameraOffset.x = 0;
            boyfriend.cameraOffset.y = 100;
            FlxG.camera.snapToTarget();
        case 464:
            camZooming = false;
            FlxTween.tween(camGame, {zoom: 0.5}, 12, {ease: FlxEase.expoInOut});
            FlxG.camera.followLerp = 0;
            FlxTween.tween(camGame.scroll, {x: -950, y: -450}, 12, {ease: FlxEase.expoInOut});
            noFuckingCamZooming = true;
        case 496:
            FlxTween.cancelTweensOf(camGame);
            FlxTween.tween(camGame, {zoom: 0.56}, 1.4, {ease: FlxEase.circOut});
        case 504:
            camHUD.visible = false;
        case 505:
            black.alpha = 1;
        case 508:
            camGame.fade(FlxColor.WHITE, 1.4, false);
            FlxG.camera.followLerp = 0.04;
            noFuckingCamZooming = false;
            boyfriend.cameraOffset.x = 0;
        case 512:
            black.visible = false;
            camGame.fade(FlxColor.BLACK, 0, true);
            camHUD.visible = true;
            camHUD.flash(FlxColor.RED);
            boyfriend.cameraOffset.y = -100;
            camZoomingInterval = 1;
            muffinZoom = 0.55;
        case 655:
            camGame.fade(FlxColor.BLACK, 3, false);
            for (a in hudShit) FlxTween.tween(a, {alpha: 0}, 3);
            for (a in playerStrums) FlxTween.tween(a, {alpha: 0}, 3);
            for (a in cpuStrums) FlxTween.tween(a, {alpha: 0}, 3);

            if (ending == 'bad'){
                insert(0, pic = new FlxSprite().loadGraphic(Paths.image(ending + 'EndingPic'))).scale.set(0.65, 0.65);
                pic.cameras = [camOther];
                pic.screenCenter();
                pic.alpha = 0;
                FlxTween.tween(pic, {alpha: 1}, 3);
            }
        case 672:
            FlxTween.tween(pic, {alpha: 0}, 10);
    }
    if (Options.camZoomOnBeat && FlxG.camera.zoom < maxCamZoom && curBeat % camZoomingInterval == 0 && noFuckingCamZooming) camHUD.zoom += 0.03 * camZoomingStrength;
}

function flick(obj, min, max, l) {
    lol = new FlxTimer().start(FlxG.random.float(min, max), () -> {
        obj.visible = !obj.visible;
        lol.time = FlxG.random.float(min, max);
        if (lol.loopsLeft == 0) obj.visible = true;
    }, l);
}

// video handling shit

function onSubstateOpen() 
    for (v in videos) if (v != null && paused) v.pause();

function onSubstateClose()
    for (v in videos) if (v != null && paused) v.resume();

function onFocus() { onSubstateOpen(); } // lil fix for when the window regains focus

function destroy(){
    for (v in videos){
        //v.remove();
        //v.destroy();
        // gives an error :( sorry idk how to fix
    }
}

function postUpdate() {
    if (noFuckingCamZooming) camHUD.zoom = lerp(camHUD.zoom, defaultHudZoom, 0.05);

    if (floatItems){
        stage.getSprite('train').y = Math.sin(Conductor.songPosition / 1000) * 100 - 719;
        stage.getSprite('wagon').y = Math.sin(Conductor.songPosition / 1200) * 125 - 850;
        stage.getSprite('debris1').y = Math.sin(Conductor.songPosition / 700) * 150 - 850;
    }
    tomHead.y = Math.sin(Conductor.songPosition / 200) * 25 - 1500;
    tomEyes.y = Math.sin(Conductor.songPosition / 200) * 25 - 749;
    tomHead.angle = FlxG.random.float(-1, 1);
    tomEyes.offset.set(FlxG.random.float(-3, 3), FlxG.random.float(-3, 3));
}

function onCameraMove(e){
    FlxTween.cancelTweensOf(tomEyes);
    FlxTween.tween(tomEyes, {x: (curCameraTarget == 0 ? -420 : -380)}, 0.5);
}

function onNoteHit(e){
    if (curBeat >= 200) e.showSplash = false;
    if (noFuckingCamZooming) e.enableCamZooming = false;
}

function updateStrumSkin(theFucking:Strum, newSkin:String, id:Int) {
    theFucking.frames = Paths.getSparrowAtlas(newSkin);
    theFucking.animation.addByPrefix('green', 'arrowUP');
    theFucking.animation.addByPrefix('blue', 'arrowDOWN');
    theFucking.animation.addByPrefix('purple', 'arrowLEFT');
    theFucking.animation.addByPrefix('red', 'arrowRIGHT');
    theFucking.antialiasing = Options.antialiasing;
    theFucking.setGraphicSize(Std.int(theFucking.width * 0.7));
    theFucking.animation.addByPrefix('static', 'arrow' + ["left", "down", "up", "right"][id].toUpperCase());
    theFucking.animation.addByPrefix('pressed', ["left", "down", "up", "right"][id] + ' press', 24, false);
    theFucking.animation.addByPrefix('confirm', ["left", "down", "up", "right"][id] + ' confirm', 24, false);
    theFucking.animation.play('static');
    theFucking.updateHitbox();
}

function updateNoteSkin(theFucker:Note, newSkin:String){
    var idk = theFucker.animation.name;
    theFucker.frames = Paths.getSparrowAtlas(newSkin);
    theFucker.animation.addByPrefix(idk, switch(idk){
        case 'scroll': ['purple', 'blue', 'green', 'red'][theFucker.strumID % 4] + '0';
        case 'hold': ['purple hold piece', 'blue hold piece', 'green hold piece', 'red hold piece'][theFucker.strumID % 4];
        case 'holdend': ['pruple end hold', 'blue hold end', 'green hold end', 'red hold end'][theFucker.strumID % 4] + '0';
    });
    theFucker.animation.play(idk);
    theFucker.updateHitbox();
}

function onGameOver(e) {
    if(controls.RESET) e.cancel();
}
// dont fucking kill yourself
