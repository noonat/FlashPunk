package
{
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.utils.Data;
	
	public class Main extends Engine
	{
		function Main()
		{
			super(400, 300);
			FP.screen.scale = 2;
			FP.world = new World;
			FP.console.enable();
			FP.console.debug = false;
			FP.console.visible = true;
			FP.alarm(0.1, function():void { FP.console.paused = true; });
		}
		
		override public function init():void
		{
			// poor man's tests ;_;
			Data.load();
			FP.console.log('fooInt', Data.readInt('fooInt', -1));
			FP.console.log('fooUint', Data.readUint('fooUint', 0));
			FP.console.log('fooBool', Data.readBool('fooBool', false));
			FP.console.log('fooString', Data.readString('fooString', 'unset'));
			Data.writeInt('fooInt', 42);
			Data.writeUint('fooUint', uint.MAX_VALUE);
			Data.writeBool('fooBool', true);
			Data.writeString('fooString', 'ohai');
			Data.save();
		}
	}
}
