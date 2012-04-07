package com.macro.gUI.managers
{
    import com.macro.gUI.assist.TextStyle;
    import com.macro.gUI.skin.ISkin;
    import com.macro.gUI.skin.StyleDef;
    import com.macro.gUI.skin.impl.BitmapSkin;
    import com.macro.gUI.skin.impl.SpriteSkin;

    import flash.display.BitmapData;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    import flash.text.TextFormatAlign;
    import flash.utils.Dictionary;


    /**
     * 皮肤管理器
     * @author Macro <macro776@gmail.com>
     *
     */
    public class SkinManager
    {
		
		/**
		 * 皮肤样式列表
		 */
        private var _skin:Dictionary;

		/**
		 * 文本样式列表
		 */
        private var _style:Dictionary;

		
		
		/**
		 * 皮肤管理器
		 * 
		 */
        public function SkinManager()
        {
            _skin = new Dictionary();
            _style = new Dictionary();
            initStyleDefines();
        }

		
        /**
         * 注册皮肤
         * @param id 皮肤定义关键字，参见SkinDef
         * @param value 皮肤图元，目前支持BitmapData, Sprite等格式
         * @param grid 九切片中心区域矩形。注意，缩放将使用此矩形的left, top, right, bottom值，而不是width, height。
         * 当right大于left时，皮肤可以水平缩放，当bottom大于top时皮肤可以垂直缩放
         * @param align 皮肤对齐方式，仅在使用非完全缩放的皮肤时有效。
         * 请使用LayoutAlign枚举，可按此方式设置左上角对齐：LayoutAlign.LEFT | LayoutAlign.TOP
         * @return
         *
         */
        public function setSkin(id:String, value:Object, grid:Rectangle = null, align:int = 0x11):ISkin
        {
            if (grid == null)
            {
                grid = new Rectangle();
            }

            var s:ISkin;
            if (value is BitmapData)
            {
                s = new BitmapSkin(BitmapData(value), grid, align);
            }
            else if (value is Sprite)
            {
                s = new SpriteSkin(Sprite(value), grid, align);
            }
            else
            {
                throw new Error("Unsupport skin class type!");
            }

            _skin[id] = s;
            return s;
        }


        /**
         * 获取皮肤
         * @param id 皮肤定义关键字，参见SkinDef
         * @return
         *
         */
        public function getSkin(id:String):ISkin
        {
            return _skin[id];
        }



        /**
         * 设置文本样式
         * @param id 文本样式定义关键字，参见StyleDef
         * @param style
         *
         */
        public function setStyle(id:String, style:TextStyle):void
        {
            _style[id] = style;
        }

		
        /**
         * 获取文本样式
         * @param id 文本样式定义关键字，参见StyleDef
         * @return
         *
         */
        public function getStyle(id:String):TextStyle
        {
            return _style[id];
        }

		
		
        /**
         * 初始化内置的样式定义
         *
         */
        private function initStyleDefines():void
        {
            var s:TextStyle;

            //普通文本样式
            s = new TextStyle();
            _style[StyleDef.NORMAL] = s;

            //禁用文本样式
            s = new TextStyle();
            s.color = 0x999999;
            _style[StyleDef.DISABLE] = s;

            //文本块样式
            s = new TextStyle();
            s.color = 0xFFFFFF;
            s.multiline = true;
            s.wordWrap = true;
            _style[StyleDef.TEXTAREA] = s;

            //单元格文本样式
            s = new TextStyle();
            s.bold = true;
            s.color = 0xFFFFFF;
            _style[StyleDef.CELL] = s;

            //窗口标题栏文本样式
            s = new TextStyle();
            s.size = 14;
            s.bold = false;
            s.color = 0xFFFFFF;
            _style[StyleDef.WINDOW_TITLE] = s;

            //输入文本框样式
            s = new TextStyle();
            s.color = 0xFFFFFF;
            s.maxChars = 50;
            _style[StyleDef.TEXTINPUT] = s;

            //图标按钮文本样式
            s = new TextStyle();
            s.color = 0xFFFFFF;
            s.size = 10;
            s.align = TextFormatAlign.RIGHT;
            _style[StyleDef.ICONBUTTON] = s;

            //图标按钮禁用文本样式
            s = new TextStyle();
            s.color = 0x999999;
            s.size = 8;
            s.align = TextFormatAlign.RIGHT;
            _style[StyleDef.ICONBUTTON_DISABLE] = s;

            //链接按钮普通样式
            s = new TextStyle();
            s.color = 0x0000FF;
            s.underline = true;
            _style[StyleDef.LINKBUTTON_NORMAL] = s;

            //链接按钮悬停样式
            s = new TextStyle();
            s.color = 0x0000FF;
            _style[StyleDef.LINKBUTTON_OVER] = s;

            //链接按钮按下样式
            s = new TextStyle();
            s.color = 0x551A8B;
            _style[StyleDef.LINKBUTTON_DOWN] = s;

            //链接按钮禁用样式
            s = new TextStyle();
            s.color = 0x999999;
            s.underline = true;
            _style[StyleDef.LINKBUTTON_DISABLE] = s;

            //按钮普通样式
            s = new TextStyle();
            s.color = 0xFFFFFF;
            _style[StyleDef.BUTTON_NORMAL] = s;

            //按钮悬停样式
            s = new TextStyle();
            s.color = 0xFFFF00;
            _style[StyleDef.BUTTON_OVER] = s;

            //按钮按下样式
            s = new TextStyle();
            s.color = 0xFFFF00;
            _style[StyleDef.BUTTON_DOWN] = s;

            //按钮禁用样式
            s = new TextStyle();
            s.color = 0x666666;
            _style[StyleDef.BUTTON_DISABLE] = s;

            //切换按钮选中状态普通样式
            s = new TextStyle();
            s.color = 0xFF0000;
            _style[StyleDef.TOGGLEBUTTON_SELECTED] = s;

            //切换按钮选中状态悬停样式
            s = new TextStyle();
            s.color = 0xFF00FF;
            _style[StyleDef.TOGGLEBUTTON_SELECTED_OVER] = s;

            //切换按钮选中状态按下样式
            s = new TextStyle();
            s.color = 0xFF00FF;
            _style[StyleDef.TOGGLEBUTTON_SELECTED_DOWN] = s;

            //切换按钮选中状态禁用样式
            s = new TextStyle();
            s.color = 0x666666;
            _style[StyleDef.TOGGLEBUTTON_SELECTED_DISABLE] = s;
        }
    }
}
