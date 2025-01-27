package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class DialogueBox extends FlxSpriteGroup
{
	var box:FlxSprite;

	var curCharacter:String = '';

	var dialogue:Alphabet;
	var dialogueList:Array<String> = [];

	var imageJunks:Array<Int> = [];

	// SECOND DIALOGUE FOR THE PIXEL SHIT INSTEAD???
	var swagDialogue:FlxTypeText;

	var dropText:FlxText;

	public var finishThing:Void->Void;

	var portraitLeft:FlxSprite;
	var portraitRight:FlxSprite;

	var handSelect:FlxSprite;
	var bgFade:FlxSprite;

	var daCoolImage:FlxSprite;
	var curImage:Int = 0;

	public function new(talkingRight:Bool = true, ?dialogueList:Array<String>)
	{
		super();

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'autumn':
				FlxG.sound.playMusic('assets/music/Autumn_Dialogue' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				imageJunks = [0, 1, 2, 2, 3, 4, 5, 6, 6, 6, 7, 8, 8, 9, 10, 11, 12, 13, 14, 15];
			case 'corruption':
				FlxG.sound.playMusic('assets/music/Corruption_Dialogue' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				imageJunks = [0, 0, 1, 1, 2, 3, 4, 5];
			case 'leaf-decay':
				FlxG.sound.playMusic('assets/music/Theo_Dialogue_Theme' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				imageJunks = [0, 1, 2, 3, 4, 4, 5];
			case 'dread':
				imageJunks = [0, 1, 2, 3, 4, 5];
			case 'senpai':
				FlxG.sound.playMusic('assets/music/Lunchbox' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'thorns':
				FlxG.sound.playMusic('assets/music/LunchboxScary' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
			case 'dread':
				FlxG.sound.playMusic('assets/music/trans' + TitleState.soundExt, 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), 0xFFB3DFd8);
		bgFade.scrollFactor.set();
		bgFade.alpha = 0;
		add(bgFade);

		new FlxTimer().start(0.83, function(tmr:FlxTimer)
		{
			bgFade.alpha += (1 / 5) * 0.7;
			if (bgFade.alpha > 0.7)
				bgFade.alpha = 0.7;
		}, 5);

		// daCoolImage = new FlxSprite();
		// daCoolImage.scrollFactor.set();
		// add(daCoolImage);

		portraitLeft = new FlxSprite(232 - 135, 229).loadGraphic('assets/images/dialogueJunk/chars/th_norm.png');
		portraitLeft.setGraphicSize(Std.int(portraitLeft.width * 0.7));
		portraitLeft.updateHitbox();
		portraitLeft.scrollFactor.set();
		portraitLeft.visible = false;
		portraitLeft.antialiasing = true;

		portraitRight = new FlxSprite((532 + 285 + 35), 228).loadGraphic('assets/images/dialogueJunk/chars/bf_norm.png');
		portraitRight.setGraphicSize(Std.int(portraitRight.width * 0.7));
		portraitRight.updateHitbox();
		portraitRight.scrollFactor.set();
		portraitRight.visible = false;
		portraitRight.antialiasing = true;

		box = new FlxSprite(-20, 45);

		portraitLeft.y = 439 - portraitLeft.height;
		portraitRight.y = 439 - portraitRight.height;

		switch (PlayState.SONG.song.toLowerCase())
		{
            default:
				box.frames = FlxAtlasFrames.fromSparrow('assets/images/dialogueJunk/dialogueBox-coolswag.png',
					'assets/images/dialogueJunk/dialogueBox-pixel.xml');
				box.animation.addByPrefix('normalOpen', 'Text Box Appear', 24, false);
				box.animation.addByIndices('normal', 'Text Box Appear', [4], "", 24);
		}

		box.animation.play('normalOpen');
		box.setGraphicSize(Std.int(box.width * PlayState.daPixelZoom * 0.9));
		box.updateHitbox();
		add(box);
		add(portraitRight);
		add(portraitLeft);

		handSelect = new FlxSprite(FlxG.width * 0.9, FlxG.height * 0.9).loadGraphic('assets/images/dialogueJunk/hand_textbox.png');
		//add(handSelect);

		box.screenCenter(X);
		//portraitLeft.screenCenter(X);

		if (!talkingRight)
		{
			// box.flipX = true;
		}

		dropText = new FlxText(242, 502, Std.int(FlxG.width * 0.6), "", 32);
		dropText.font = 'Pixel Arial 11 Bold';
		dropText.color = 0xFF888888;
		add(dropText);

		swagDialogue = new FlxTypeText(240, 500, Std.int(FlxG.width * 0.6), "", 32);
		swagDialogue.font = 'Pixel Arial 11 Bold';
		swagDialogue.color = 0xFFFFFFFF;
		add(swagDialogue);

		dialogue = new Alphabet(0, 80, "", false, true);
		// dialogue.x = 90;
		// add(dialogue);

		this.dialogueList = dialogueList;
	}

	var dialogueOpened:Bool = false;
	var dialogueStarted:Bool = false;

	override function update(elapsed:Float)
	{
		// HARD CODING CUZ IM STUPDI
		// ninja is stupdi

		dropText.text = swagDialogue.text;

		if (box.animation.curAnim != null)
		{
			if (box.animation.curAnim.name == 'normalOpen' && box.animation.curAnim.finished)
			{
				box.animation.play('normal');
				dialogueOpened = true;
			}
		}

		if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}
		#if mobile
		var justTouched:Bool = false;

		for (touch in FlxG.touches.list)
		{
			justTouched = false;
			
			if (touch.justReleased){
				justTouched = true;
			}
		}
		#end
		if (FlxG.keys.justPressed.ANY #if mobile || justTouched #end && dialogueStarted == true)
		{
			remove(dialogue);

			FlxG.sound.play('assets/sounds/clickText' + TitleState.soundExt, 0.8);

			if (dialogueList[1] == null)
			{
				if (!isEnding)
				{
					isEnding = true;

					if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
						FlxG.sound.music.fadeOut(2.2, 0);

					new FlxTimer().start(0.2, function(tmr:FlxTimer)
					{
						box.alpha -= 1 / 5;
						bgFade.alpha -= 1 / 5 * 0.7;
						portraitLeft.visible = false;
						portraitRight.visible = false;
						swagDialogue.alpha -= 1 / 5;
						dropText.alpha = swagDialogue.alpha;
					}, 5);

					new FlxTimer().start(1.2, function(tmr:FlxTimer)
					{
						finishThing();
						kill();
					});
				}
			}
			else
			{
				dialogueList.remove(dialogueList[0]);
				startDialogue();
			}
		}

		super.update(elapsed);
	}

	var isEnding:Bool = false;
	var lastChar:String;

	function startDialogue():Void
	{
		cleanDialog();

		// var theDialog:Alphabet = new Alphabet(0, 70, dialogueList[0], false, true);
		// dialogue = theDialog;
		// add(theDialog);

		var expression:String;
		var charAndExpression:Array<String> = [];

		// swagDialogue.text = ;
		swagDialogue.resetText(dialogueList[0]);
		swagDialogue.start(0.035, true);

		charAndExpression = getExpression(curCharacter);
		expression = charAndExpression[1];

		switch (charAndExpression[0])
		{
			case 'theo':
				portraitRight.visible = false;
				portraitLeft.visible = true;
				portraitLeft.loadGraphic('assets/images/dialogueJunk/chars/th_' + expression + '.png');
				if (lastChar != charAndExpression[0])
					tweenThisCrap(portraitLeft);
				FlxG.sound.play('assets/sounds/theo${FlxG.random.int(1, 3)}.ogg', 1);
			case 'boyfriend':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.flipX = true;
				portraitRight.loadGraphic('assets/images/dialogueJunk/chars/bf_' + expression + '.png');
				if (lastChar != charAndExpression[0])
					tweenThisCrap(portraitRight);
				FlxG.sound.play('assets/sounds/bf${FlxG.random.int(1, 3)}.ogg', 1);
			case 'vanus':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.flipX = false;
				portraitRight.loadGraphic('assets/images/dialogueJunk/chars/va_' + expression + '.png');
				if (lastChar != charAndExpression[0])
					tweenThisCrap(portraitRight);
			case 'calliope':
				portraitLeft.visible = false;
				portraitRight.visible = true;
				portraitRight.flipX = true;
				portraitRight.loadGraphic('assets/images/dialogueJunk/chars/ca_' + expression + '.png');
				if (lastChar != charAndExpression[0])
					tweenThisCrap(portraitRight);
				FlxG.sound.play('assets/sounds/calliope${FlxG.random.int(1, 3)}.ogg', 1);
		}

		// daCoolImage.loadGraphic('assets/images/dialogueJunk/images/' + PlayState.SONG.song.toLowerCase() + '/dia' + imageJunks[curImage] + '.png');
		curImage += 1;
		lastChar = charAndExpression[0];
	}

	function cleanDialog():Void
	{
		var splitName:Array<String> = dialogueList[0].split(":");
		curCharacter = splitName[0].toLowerCase();
		dialogueList[0] = dialogueList[0].substr(splitName[0].length + 1).trim();
	}

	function getExpression(sussyImposter:String)
	{
		return sussyImposter.split('-');
	}

	function tweenThisCrap(poop:FlxSprite):Void
	{
		poop.scale.set(0, 0);
		FlxTween.cancelTweensOf(poop);
		FlxTween.tween(poop, {'scale.x': 0.95, 'scale.y': 1.15}, 0.125, {ease: FlxEase.quadOut, onComplete: function(twn:FlxTween){
			FlxTween.tween(poop, {'scale.x': 0.7, 'scale.y': 0.7}, 0.1, {ease: FlxEase.quadIn});
		}});
	}
}
