package com.macro.logging
{
	import com.macro.utils.StrUtil;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.XMLSocket;
	import flash.utils.getQualifiedClassName;


	public class SOSAppender implements IAppender
	{
		private static const _sos_prefix:String = "!SOS";

		private var _server:String = "localhost";

		private var _port:int = 4444;


		private var _socket:XMLSocket;

		private var _cache:Vector.<String>;

		private var _useSocket:Boolean;


		public function SOSAppender()
		{
			_useSocket = true;
			_cache = new Vector.<String>();
		}


		private function connect():Boolean
		{
			if (!_socket)
			{
				_socket = new XMLSocket();
				_socket.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				_socket.addEventListener(Event.CONNECT, onConnect);
				_socket.addEventListener(Event.CLOSE, onClose);
				_socket.connect(_server, _port);
			}

			return _socket.connected;
		}

		private function onConnect(e:Event):void
		{
			for each (var log:String in _cache)
			{
				_socket.send(log + "\n");
			}
			_cache.splice(0, uint.MAX_VALUE);
		}

		private function onIOError(e:IOErrorEvent):void
		{
			_socket.close();
			_useSocket = false;
			_socket = null;

			send(getQualifiedClassName(this), "XMLSocket IOError", LogLevel.ERROR);

			for each (var log:String in _cache)
			{
				trace(log);
			}
			_cache = null;
		}

		private function onSecurityError(e:SecurityErrorEvent):void
		{
			_socket.close();
			_useSocket = false;
			_socket = null;

			send(getQualifiedClassName(this), "XMLSocket SecurityError", LogLevel.ERROR);

			for each (var log:String in _cache)
			{
				trace(log);
			}
			_cache = null;
		}

		private function onClose(e:Event):void
		{
			_useSocket = false;
			_socket = null;

			send(getQualifiedClassName(this), "XMLSocket Closed", LogLevel.ERROR);

			for each (var log:String in _cache)
			{
				trace(log);
			}
			_cache = null;
		}

		public function send(category:String, message:String, level:int):String
		{
			var xmlMessage:XML = <showMessage key={LogLevel.getLevelString(level)}/>;
			var xmlBody:XML = new XML("<![CDATA[" + category + ": " + message + "]]>");
			xmlMessage.appendChild(xmlBody);

			var msg:String = _sos_prefix + xmlMessage.toXMLString();

			if (_useSocket)
			{
				if (connect())
				{
					_socket.send(msg + "\n");
				}
				else
				{
					_cache.push(msg);
				}
			}
			else
			{
				trace(msg);
			}

			return msg;
		}
	}
}
