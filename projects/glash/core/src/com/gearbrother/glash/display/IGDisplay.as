package com.gearbrother.glash.display {
	import com.gearbrother.glash.common.geom.GDimension;

	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.as3commons.lang.IDisposable;

	public interface IGDisplay extends IGToolTipable, IGCursorable, IGDatable, IGTickable, IGPaintManagable, IEventDispatcher {
		function remove():void;
	}
}
