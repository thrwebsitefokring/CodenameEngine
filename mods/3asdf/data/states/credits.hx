
var allThePeople:FlxSprite;
var select;
var curSelected:Int = 0;

function postCreate(){
	allThePeople = new FlxSprite(0, 0).loadGraphic(Paths.image('Credits/creditThing'));
	allThePeople.scale.set(0.55, 0.55);
	allThePeople.screenCenter();
	add(allThePeople);

	add(select = new FlxSprite(300, 0).loadGraphic(Paths.image('menuTriangle')));

	changePerson(0);
}

function postUpdate(e){
	if (controls.DOWN_P) changePerson(1);
	if (controls.UP_P) changePerson(-1);
	if (controls.RIGHT_P) changePerson(8);
	if (controls.LEFT_P) changePerson(-8);
	if (controls.ACCEPT) goToPerson();
	if (controls.BACK) FlxG.switchState(new ModState('AsdfMenu'));
}

function changePerson(ok:Int){
	curSelected = FlxMath.wrap(curSelected + ok, 0, 15);
	if (curSelected >= 8){
		select.x = 700;
		select.y = ((curSelected - 8) * 80) + 50;
	}
	else{
		select.x = 300;
		select.y = (curSelected * 80) + 50;
	}
}

function goToPerson(){
	switch(curSelected){
		case 0: CoolUtil.openURL("https://x.com/Corleyrecord");
		case 1: CoolUtil.openURL("https://x.com/biltro_");
		case 2: CoolUtil.openURL("https://x.com/f4kywazhere");
		case 3: CoolUtil.openURL("https://x.com/IBNVintage");
		case 4: CoolUtil.openURL("https://x.com/littlekenuxx");
		case 5: CoolUtil.openURL("https://x.com/SpiritualOsu");
		case 6: CoolUtil.openURL("https://x.com/OLLIEE617283");
		case 7: CoolUtil.openURL("https://gamebanana.com/members/1934007");
		case 8: CoolUtil.openURL("https://x.com/AidenDrawzStuff");
		case 9: CoolUtil.openURL("https://x.com/Vechett_");
		case 10: CoolUtil.openURL("https://x.com/Sossybaka222");
		case 11: CoolUtil.openURL("https://x.com/hypsk8r");
		case 12: CoolUtil.openURL("https://x.com/loserxsinging");
		case 13: CoolUtil.openURL("https://x.com/AidenDoesStuff1");
		case 14: CoolUtil.openURL("https://www.youtube.com/@BirdButYoutube");
		case 15: CoolUtil.openURL("https://x.com/Memersquad");
	}
}