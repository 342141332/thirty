package com.gearbrother.glash.util.lang
{

	public class XmlUtil
	{
		public function XmlUtil()
		{
		}

		public static function deleteNode(node:XML):void
		{
			if (node != null && node.parent() != null)
			{
				delete node.parent().children()[node.childIndex()];
			}
		}
		
		public static function replaceNode(old:XML, replace:*):void {
			var parent:XML = old.parent();
			parent.children()[old.childIndex()] = replace;
		}
	}
}