package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	public class Main extends Engine
	{
		function Main()
		{
			super(400, 300);
			FP.screen.scale = 2;
			FP.world = new Game();
		}
	}
}
