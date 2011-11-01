package com.macro.utils
{
	import flexunit.framework.Assert;
	
	public class StrUtil_Tester
	{		
		[Test]
		public function testFormat():void
		{
			var f:String = StrUtil.format("Role ID[{0}] Identity:{1} <{0}>", ["ENEMY", 2]);
			Assert.assertEquals(f, "Role ID[ENEMY] Identity:2 <ENEMY>");
		}
		
		[Test]
		public function testGetTimeString():void
		{
			var d:Date = new Date(2010, 10, 10, 14, 5, 22, 4);
			var f:String = StrUtil.getTimeString(d);
			Assert.assertEquals(f, "14:05:22:004");
		}
		
		[Test]
		public function testTrimLines():void
		{
			var f:String = StrUtil.trimLines("Role ID:\r Identity:\n");
			Assert.assertEquals(f, "Role ID:");
		}
	}
}