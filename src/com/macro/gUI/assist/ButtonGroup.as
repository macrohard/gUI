package com.macro.gUI.assist
{
	import com.macro.gUI.core.feature.ISelect;
	
	import flash.utils.Dictionary;


	/**
	 * 按钮组，自动将同组的其它单选按钮给置为false
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class ButtonGroup
	{

		private var _groups:Dictionary;

		public function ButtonGroup()
		{
			_groups = new Dictionary(true);
		}

		/**
		 * 获取群组标识
		 * @param rdb
		 * @return
		 *
		 */
		public function getGroupId(control:ISelect):String
		{
			return _groups[control];
		}

		/**
		 * 设置群组标识
		 * @param rdb
		 * @param groupId
		 *
		 */
		public function setGroupId(control:ISelect, groupId:String):void
		{
			_groups[control] = groupId;
		}

		/**
		 * 取消同组其它单选按钮的选中状态
		 * @param rdb
		 *
		 */
		public function unselect(control:ISelect):void
		{
			var id:String = _groups[control];
			if (id == null)
			{
				return;
			}
			for (var obj:Object in _groups)
			{
				var tmp:ISelect = obj as ISelect;
				if (_groups[tmp] == id && tmp != control)
				{
					tmp.selected = false;
				}
			}
		}
	}
}
