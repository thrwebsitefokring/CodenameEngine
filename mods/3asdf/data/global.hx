import funkin.backend.MusicBeatTransition;
import funkin.backend.utils.WindowUtils;
import lime.graphics.Image;
import funkin.backend.system.framerate.Framerate;
import openfl.text.TextFormat;

var shader = new CustomShader('lowquality');

var redirectStates:Map<FlxState, String> = [
    TitleState => 'Intro',
    MainMenuState => 'AsdfMenu',
    FreeplayState => 'AsdfMenu',
    StoryMenuState => 'AsdfMenu'
];

function preStateSwitch() {
    MusicBeatTransition.script = "data/states/transition";
    for (redirectState in redirectStates.keys()) 
        if (Std.isOfType(FlxG.game._requestedState, redirectState)) 
            FlxG.game._requestedState = new ModState(redirectStates.get(redirectState));
}

function postStateSwitch(){
    Framerate.codenameBuildField.visible = false;
	Framerate.memoryCounter.memoryText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('arial.ttf')), 18, -1);
	Framerate.memoryCounter.memoryPeakText.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('arial.ttf')), 18, -1);
  	Framerate.fpsCounter.fpsNum.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('arial.ttf')), 20, -1);
  	Framerate.fpsCounter.fpsLabel.defaultTextFormat = new TextFormat(Paths.getFontName(Paths.font('arial.ttf')), 15, -1);
}

function new() {
    windowShit('muffin time');
    FlxG.game.addShader(shader); 
    window.setIcon(Image.fromBytes(Assets.getBytes(Paths.image('muffin'))));
}

function destroy() {
    windowShit("Friday Night Funkin' - Codename Engine");
    FlxG.game.removeShader(shader);
}

function windowShit(title) WindowUtils.winTitle = window.title = title;
