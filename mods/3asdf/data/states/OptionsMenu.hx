var white:FlxSprite = new FlxSprite(0,0).makeSolid(FlxG.width, FlxG.height, FlxColor.WHITE);

function postCreate(){
    white.scale.set(1300, 720); //im so sorry
    insert(1,white);
    white.scrollFactor.set();
    white.screenCenter(FlxAxes.XY);
}