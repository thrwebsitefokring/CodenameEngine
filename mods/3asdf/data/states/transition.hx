import hxvlc.flixel.FlxVideoSprite;

var stat = new FlxVideoSprite(320, 180);
function create(event) {
	event.cancel();

	stat.load(Assets.getPath(Paths.file("videos/static-transition.mkv")));  
    stat.cameras = [transitionCamera];
	stat.scale.set(2, 2);
    add(stat);

	if (newState != null){
		stat.play();
		stat.bitmap.onEndReached.add(function(){finish();});
	}
	else finish();
}