package com.macro.gUI.assist
{
	import com.macro.gUI.composite.RadioButton;

	import flash.utils.Dictionary;


	/**
	 * 单选按钮组，自动将同组的其它单选按钮给置为false
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class RadioButtonGroup
	{

		private var _rdbGroups:Dictionary;

		public function RadioButtonGroup()
		{
			_rdbGroups = new Dictionary(true);
		}

		/**
		 * 获取群组标识
		 * @param rdb
		 * @return
		 *
		 */
		public function getGroupId(rdb:RadioButton):int
		{
			return _rdbGroups[rdb];
		}

		/**
		 * 设置群组标识
		 * @param rdb
		 * @param groupId
		 *
		 */
		public function setGroupId(rdb:RadioButton, groupId:int):void
		{
			_rdbGroups[rdb] = groupId;
		}

		/**
		 * 取消同组其它单选按钮的选中状态
		 * @param rdb
		 *
		 */
		public function select(rdb:RadioButton):void
		{
			var id:int = _rdbGroups[rdb];
			if (id == 0)
			{
				return;
			}
			for (var obj:Object in _rdbGroups)
			{
				var btn:RadioButton = obj as RadioButton;
				if (_rdbGroups[btn] == id && btn != rdb)
				{
					btn.selected = false;
				}
			}
		}
	}
}
