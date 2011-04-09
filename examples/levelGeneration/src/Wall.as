package  
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Pixelmask;
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Wall extends Entity
	{
		
		public function Wall(grass:Image, mask:BitmapData) 
		{
			super(0, 0, grass, new Pixelmask(mask));
		}
		
	}

}