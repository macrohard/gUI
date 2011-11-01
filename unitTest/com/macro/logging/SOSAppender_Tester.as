package com.macro.logging
{
	import flexunit.framework.Assert;

	public class SOSAppender_Tester
	{		
		private static var sosAppender:SOSAppender;
		
		private static var sendMsg:String;
		
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
			sosAppender =  new SOSAppender();
			sendMsg = "this is a test message!";
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
			sosAppender = null;
		}
		
		[Test]
		public function testSend1():void
		{
			var cate:String = Logger.getCategory(this);
			var f:String = sosAppender.send(cate, sendMsg, LogLevel.DEBUG);
			Assert.assertEquals(f, "!SOS<showMessage key=\"DEBUG\"><![CDATA[" + cate + ": " + sendMsg + "]]></showMessage>");
		}
		
	}
}