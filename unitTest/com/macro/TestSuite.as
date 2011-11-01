package com.macro
{
	import com.macro.logging.LogFilter_Tester;
	import com.macro.logging.SOSAppender_Tester;
	import com.macro.logging.TraceAppender_Tester;
	import com.macro.utils.StrUtil_Tester;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var test1:StrUtil_Tester;
		public var test2:LogFilter_Tester;
		public var test3:SOSAppender_Tester;
		public var test4:TraceAppender_Tester;
	}
}