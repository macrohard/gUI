package com.macro.logging
{
	import flexunit.framework.Assert;
	
	public class TraceAppender_Tester
	{		
		private static var traceAppender:TraceAppender;
		
		private static var sendMsg:String;
		
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			traceAppender =  new TraceAppender();
			sendMsg = "this is a test message!";
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
			traceAppender = null;
		}
		
		
		[Test(order = 1)]
		public function testSend1():void
		{
			traceAppender.includeTime = false;
			var cate:String = Logger.getCategory(this);
			var f:String = traceAppender.send(cate, sendMsg, LogLevel.DEBUG);
			Assert.assertEquals(f, "[DEBUG] com.macro.logging.TraceAppender_Tester: " + sendMsg);
		}
		
		[Test(order = 2)]
		public function testSend2():void
		{
			traceAppender.includeCategory = false;
			var cate:String = Logger.getCategory(this);
			var f:String = traceAppender.send(cate, sendMsg, LogLevel.DEBUG);
			Assert.assertEquals(f, "[DEBUG] " + sendMsg);
		}
		
		[Test(order = 3)]
		public function testSend3():void
		{
			traceAppender.includeLevel = false;
			traceAppender.includeCategory = true;
			var cate:String = Logger.getCategory(this);
			var f:String = traceAppender.send(cate, sendMsg, LogLevel.DEBUG);
			Assert.assertEquals(f, "com.macro.logging.TraceAppender_Tester: " + sendMsg);
		}
		
		[Test(order = 4)]
		public function testSend4():void
		{
			traceAppender.includeCategory = false;
			var cate:String = Logger.getCategory(this);
			var f:String = traceAppender.send(cate, sendMsg, LogLevel.DEBUG);
			Assert.assertEquals(f, sendMsg);
		}
	}
}