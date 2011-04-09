package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Noel Berry
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{
			super(400, 300);
			FP.screen.scale = 2;
			FP.world = new Game();
		}
		
	}
	
}