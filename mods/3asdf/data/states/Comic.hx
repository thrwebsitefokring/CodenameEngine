
import funkin.backend.MusicBeatState;
import funkin.backend.utils.DiscordUtil;

var lol = false;
var dick = false;

var am = 0;

function create() {
	DiscordUtil.changePresence('PURGATORY.', "");
	FlxG.camera.bgColor = FlxColor.BLACK;

    add(comic = new FlxSprite().loadGraphic(Paths.image('comic/1'))).screenCenter().antialiasing = true;
	comic.alpha = 0.001;
	comic.scale.set(0.7, 0.7);
	comic.angle = 1;

	add(fuck = new FlxSprite().loadGraphic(Paths.image('comic/2'))).screenCenter().y += 900;
	fuck.antialiasing = true;
	fuck.scale.set(1.05, 1.05);

	FlxG.sound.music.stop();
	FlxG.sound.playMusic(Paths.music('comic'), 1, true);

	new FlxTimer().start(2.45, () -> {
		FlxTween.tween(comic, {alpha: 1, angle: 0}, 2, {ease: FlxEase.expoOut});
		FlxTween.tween(comic.scale, {x: 1.05, y: 1.05}, 2, {ease: FlxEase.expoOut, onComplete: function(_:FlxTween) {
			add(enter = new FlxSprite(710, 20).loadGraphic(Paths.image('comic/enter'))).antialiasing = true;
            enter.alpha = 0;

			FlxTween.tween(enter, {alpha: 1}, 0.7);
			lol = true;
		}});
	});
}

function update() {
	if (lol) {
		if (controls.ACCEPT && !dick) {
			dick = true;
			FlxTween.tween(FlxG.camera.scroll, {y: FlxG.camera.scroll.y + 898}, 3, {ease: FlxEase.quadInOut, onComplete: function(t:FlxTween) {
				new FlxTimer().start(1.2, () -> {
					FlxTween.tween(FlxG.sound.music, {pitch: 0}, 2, {onComplete: function(t:FlxTween) {
						PlayState.loadSong('die', 'normal');
						MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
						FlxG.switchState(new PlayState());
					}});

					FlxTween.tween(FlxG.camera, {zoom: 0.8, alpha: 0, angle: -0.7}, 1.5, {ease: FlxEase.quadInOut});
					FlxTween.num(0, 2.5, 1.5, {ease: FlxEase.quadInOut}, (v:Float) -> {am = v;});
				});
			}});
		}
	}

	if (controls.BACK && !dick) {
		FlxG.sound.music.stop();
		FlxG.switchState(new ModState('AsdfMenu'));
	}

	FlxG.camera.setPosition(FlxG.random.bool(50) ? -am : am, FlxG.random.bool(50) ? -am : am);
}