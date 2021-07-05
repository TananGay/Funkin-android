package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public var iconScale:Float = 1;
	public var iconSize:Float;
	public var defualtIconScale:Float = 1;

	var pixelIcons:Array<String> = ["bf-pixel", "senpai", "senpai-angry", "spirit"];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();
		loadGraphic(Paths.image('iconGrid'), true, 150, 150);

		antialiasing = true;
		addIcon('bf', 0);
		addIcon('bf-breakdown', 2);
		addIcon('calliope-n-bf', 2);
		addIcon('theo', 4);
		addIcon('theo-lemon', 6);
		addIcon('gf', 10);
		addIcon('calliope', 10);
		addIcon('gene', 8);
		addIcon('theo-bsides', 12);
		addIcon('theo-breakdown', 14);
		addIcon('senpai', 20);
		addIcon('bf-pixel', 22);
		
		antialiasing = !pixelIcons.contains(char);
		
		animation.play(char);
		scrollFactor.set();
		
		iconScale = defualtIconScale;
		iconSize = width;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		setGraphicSize(Std.int(iconSize * iconScale));
		updateHitbox();

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}
}
