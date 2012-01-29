package com.macro.ioc
{
	import com.macro.utils.StrUtil;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;


	/**
	 * 简易IoC反转控制容器，兼容Parsley。<br>
	 * 提供对[Inject], [Init], [ManagedEvents], [MessageDispatcher], [MessageHandler]等标签的支持。<br>
	 * 如需某个类的多个实例，可采取Beans中多次声明的方式，通过name来区分，暂不支持实例工厂方式。
	 * @author Macro <macro776@gmail.com>
	 *
	 */
	public class Context
	{
		/**
		 * 本类的完全限定类名
		 */
		private static var _type:String;


		/**
		 * Beans配置类
		 */
		private var _bean:Object;


		/**
		 * 对象名称表，由于类中名称不允许同名，因此Beans中所有对象均按名称保存在此表中
		 */
		private var _definesByName:Dictionary;

		/**
		 * 对象类型表，此表中仅保存对应的对象名称。由于可能存在多个不同名但同类型的对象，因此，此表中保存的对象不完整
		 */
		private var _definesByType:Dictionary;

		/**
		 * 临时动态对象表，动态对象可以注入Beans中声明的对象，无法注入其它动态对象。
		 */
		private var _dynamicObjects:Dictionary;


		/**
		 * 消息句柄表，以消息句柄的参数类型为键，值为HandlersCollection
		 */
		private var _handlers:Dictionary;


		public function Context()
		{
			_type = getQualifiedClassName(this);

			_dynamicObjects = new Dictionary();
			_definesByName = new Dictionary();
			_definesByType = new Dictionary();

			_handlers = new Dictionary();
		}

		/**
		 * 构建环境
		 * @param bean 配置类，Beans中声明的对象将在运行期间驻留内存
		 * @param isAutoInit 是否自动初始化
		 * @return
		 *
		 */
		public static function buildContext(bean:Class, isAutoInit:Boolean = true):Context
		{
			var context:Context = new Context();
			context._bean = new bean();

			var describe:XML = describeType(context._bean);
			var node:XML;
			for each (node in describe.*.(name() == "variable" || name() == "accessor"))
			{
				context._definesByType[node.@type.toString()] = node.@name.toString();
				context._definesByName[node.@name.toString()] = true; // 有定义
			}

			// 装配
			var name:String;
			for (name in context._definesByName)
			{
				context.assembling(context.getObjectByName(name));
			}

			if (isAutoInit)
			{
				context.initBeans();
			}

			return context;
		}


		/**
		 * 根据类型获取Beans中注册的对象
		 * @param type
		 * @return
		 *
		 */
		public function getObjectByType(type:Class):Object
		{
			return getObjectByName(_definesByType[getQualifiedClassName(type)]);
		}

		/**
		 * 根据名称获取Beans中注册的对象
		 * @param name
		 * @return
		 *
		 */
		public function getObjectByName(name:String):Object
		{
			if (_definesByName[name] != null)
			{
				if (_definesByName[name] == true)
				{
					_definesByName[name] = _bean[name];
				}
				return _definesByName[name];
			}
			return null;
		}


		/**
		 * 初始化Beans中所有注册对象
		 *
		 */
		public function initBeans():void
		{
			var name:String;
			var obj:Object;

			for (name in _definesByName)
			{
				obj = getObjectByName(name);
				callInit(obj);
			}
		}

		/**
		 * 加入动态对象。动态对象只能使用配置类中的对象进行注入，无法注入其它动态对象<br>
		 * 如果名称为null，则使用类名，如果已有同名的动态对象，则自动清除旧动态对象<br>
		 * 动态对象必须通过removeDynamicObject方法移除，否则无法释放
		 * @param obj 原始对象
		 * @param name 名称
		 *
		 */
		public function addDynamicObject(obj:Object, name:String = null):void
		{
			if (name == null)
			{
				name = getQualifiedClassName(obj);
			}

			// 移除同名旧动态对象
			removeDynamicObject(obj, name);

			assembling(obj);
			callInit(obj);
			_dynamicObjects[name] = obj;
		}

		/**
		 * 移除动态对象。
		 * @param obj
		 * @param name
		 *
		 */
		public function removeDynamicObject(obj:Object, name:String = null):void
		{
			if (name == null)
			{
				name = getQualifiedClassName(obj);
			}

			if (_dynamicObjects[name] != null)
			{
				_dynamicObjects[name] = null;
				delete _dynamicObjects[name];

				removeMessageHandlers(obj);
			}
		}

		/**
		 * 获取动态对象。
		 * @param name
		 * @return
		 *
		 */
		public function getDynamicObject(name:String):Object
		{
			return _dynamicObjects[name];
		}


		/**
		 * 装配
		 * @param obj
		 *
		 */
		private function assembling(obj:Object):void
		{
			var describe:XML = describeType(obj);
			
			setInject(describe, obj);
			setDispatcher(describe, obj);
			// 对象支持事件派发，则处理托管事件。
			// 不支持事件派发的对象，应使用[MessageDispatcher]来注入事件派发器
			if (obj is IEventDispatcher)
			{
				processManagedEvents(describe, obj);
			}
			addMessageHandlers(describe, obj);
		}

		/**
		 * 设置[Inject(id="variableName")]属性或访问器
		 * @param info
		 * @param obj
		 *
		 */
		private function setInject(describe:XML, obj:Object):void
		{
			var node:XML;
			var argNode:XML;
			var propertyName:String;
			var propertyType:String;
			var requestName:String;

			for each (node in describe.*.(name() == "variable" || name() == "accessor").metadata.(@name == "Inject"))
			{
				propertyName = node.parent().@name;
				propertyType = node.parent().@type;

				// 处理对容器环境的注入请求
				if (propertyType == _type)
				{
					obj[propertyName] = this;
					continue;
				}

				requestName = null;
				for each (argNode in node.arg.(@key == "id"))
				{
					requestName = argNode.@value;
					break;
				}

				if (requestName != null)
				{
					obj[propertyName] = getObjectByName(requestName);
				}
				else
				{
					obj[propertyName] = getObjectByType(getDefinitionByName(propertyType) as Class);
				}
			}
		}

		/**
		 * 设置[MessageDispatcher]属性或访问器
		 * @param describe
		 * @param obj
		 *
		 */
		private function setDispatcher(describe:XML, obj:Object):void
		{
			var node:XML;
			var propertyName:String;

			for each (node in describe.*.(name() == "variable" ||
					name() == "accessor").metadata.(@name == "MessageDispatcher"))
			{
				propertyName = node.parent().@name;
				obj[propertyName] = managedEventHandler;
			}
		}


		/**
		 * 对托管事件[ManagedEvents]添加侦听器
		 * @param describe
		 * @param obj
		 *
		 */
		private function processManagedEvents(describe:XML, obj:Object):void
		{
			var dispatcher:IEventDispatcher = obj as IEventDispatcher;
			var node:XML;
			var types:Array;
			var type:String;

			for each (node in describe.metadata.(@name == "ManagedEvents").arg)
			{
				types = node.@value.toString().split(",");
				for each (type in types)
				{
					type = StrUtil.trim(type);
					dispatcher.addEventListener(type, managedEventHandler, false, 0, true);
				}
			}
		}

		/**
		 * 添加消息句柄
		 * @param describe
		 * @param obj
		 */
		private function addMessageHandlers(describe:XML, obj:Object):void
		{
			var node:XML;
			var argNode:XML;
			var parameterType:String;
			var handlerInfo:HandlerInfo;
			var handlers:Vector.<HandlerInfo>;

			for each (node in describe.*.(name() == "method").metadata.(@name == "MessageHandler"))
			{
				handlerInfo = new HandlerInfo();
				handlerInfo.handler = obj[node.parent().@name.toString()];
				for each (argNode in node.arg.(@key == "selector"))
				{
					handlerInfo.selector = argNode.@value;
					break;
				}

				parameterType = node.parent().parameter.@type;

				handlers = _handlers[parameterType];
				if (handlers == null)
				{
					handlers = new Vector.<HandlerInfo>();
					_handlers[parameterType] = handlers;
				}

				handlers.push(handlerInfo);
			}
		}

		/**
		 * 移除消息句柄
		 * @param describe
		 * @param obj
		 *
		 */
		private function removeMessageHandlers(obj:Object):void
		{
			var describe:XML = describeType(obj);
			var node:XML;
			var parameterType:String;
			var handler:Function;
			var handlerInfo:HandlerInfo;
			var handlers:Vector.<HandlerInfo>;

			for each (node in describe.*.(name() == "method").metadata.(@name == "MessageHandler"))
			{
				parameterType = node.parent().parameter.@type;

				handlers = _handlers[parameterType];
				if (handlers == null)
				{
					continue;
				}

				handler = obj[node.parent().@name.toString()];

				for (var i:int = handlers.length - 1; i >= 0; i--)
				{
					handlerInfo = handlers[i];
					if (handlerInfo.handler == handler)
					{
						handlers.splice(i, 1);
					}
				}
			}
		}



		/**
		 * 调用[Init]方法
		 *
		 */
		private function callInit(obj:Object):void
		{
			var describe:XML;
			var node:XML;
			var handler:Function;

			describe = describeType(obj);
			for each (node in describe.*.(name() == "method").metadata.(@name == "Init"))
			{
				handler = obj[node.parent().@name.toString()];
				handler.apply();
			}
		}

		/**
		 * 处理托管事件
		 * @param e
		 *
		 */
		private function managedEventHandler(e:Event):void
		{
			var eventType:String = getQualifiedClassName(e);
			var handlerInfo:HandlerInfo;
			var handlers:Vector.<HandlerInfo>;
			do
			{
				handlers = _handlers[eventType];
				if (handlers != null)
				{
					for each (handlerInfo in handlers)
					{
						if (handlerInfo.selector == null)
						{
							handlerInfo.handler.call(null, e);
						}
						else
						{
							if (handlerInfo.selector.indexOf(e.type) != -1)
							{
								handlerInfo.handler.call(null, e);
							}
						}
					}
				}
				
				eventType = getQualifiedSuperclassName(getDefinitionByName(eventType));
				
			} while (eventType != null)
		}

	}
}
