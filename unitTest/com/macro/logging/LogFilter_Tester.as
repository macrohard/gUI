package com.macro.logging
{
	import flexunit.framework.Assert;

	public class LogFilter_Tester
	{
		private static var logFilter:LogFilter;
		
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			logFilter = new LogFilter(LogLevel.DEBUG);
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
			logFilter = null;
		}
		
		
		[Test(order = 1)]
		public function testLogFilter1():void
		{
			var cate:String = Logger.getCategory(this);
			logFilter.addLogLevel(cate, LogLevel.ERROR);
			Assert.assertFalse(logFilter.filter(cate, LogLevel.WARN));
		}
		
		[Test(order = 2)]
		public function testLogFilter2():void
		{
			var cate:String = Logger.getCategory(this);
			logFilter.removeLogLevel(cate);
			Assert.assertTrue(logFilter.filter(cate, LogLevel.WARN));
		}
		
		[Test(order = 3)]
		public function testLogFilter3():void
		{
			var cate:String = Logger.getCategory(this);
			Assert.assertFalse(logFilter.filter(cate, LogLevel.ALL));
		}
		
		[Test(order = 4)]
		public function testLogFilter4():void
		{
			var cate:String = "com.macro";
			logFilter.addLogLevel(cate, LogLevel.WARN);
			Assert.assertFalse(logFilter.filter(cate, LogLevel. DEBUG));
		}
		
		[Test(order = 5)]
		public function testLogFilter5():void
		{
			var cate:String = "com.macro";
			logFilter.removeLogLevel(cate);
			Assert.assertTrue(logFilter.filter(cate, LogLevel.DEBUG));
		}
		
		[Test(order = 6)]
		public function testLogFilter6():void
		{
			var cate:String = "com.macro.loging.test";
			logFilter.addLogLevel(cate, LogLevel.ERROR);
			cate = Logger.getCategory(this);
			Assert.assertTrue(logFilter.filter(cate, LogLevel.DEBUG));
		}
	}
}