package westCountrySalsa;
import simpleText.SimpleText;
import kha.Assets;
import kha.Color;
class EditorText{
    public var txtAlign:    SimpleText;
    public var txtSize:     SimpleText;
    public var txtAdvanceX: SimpleText;
    public var txtAdvanceY: SimpleText;
    public var txtSelector: SimpleText;
    public var txtAccuracy: SimpleText;
    public var txtWrapWidth: SimpleText;
    public var txt: SimpleText;
    public static var textSizeStr:  String = 'Size 8 10 12 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 35 ';
    public static var wrapWidthStr: String = ' 250 300 350 400 450 500 520 ';
    public static var accuracyStr:  String = ' WITHIN CLOSE ';
    public static var alignStr:     String = ' LEFT CENTRE RIGHT JUSTIFY ';
    public static var selectionStr: String = ' CHARACTER WORD LINE ';
    public static var dAdvanceXstr: String = 
'dAdvanceX
 -1.5
 -1
 0
 1
 1.5
 2
 2.5
 3
 3.5
 4
 4.5
 5.
';
    public static var dAdvanceYstr: String = 
'dAdvanceY
 3
 5
 10
 12
 16
 20
 25
 30
'
    public function new(){
        /*
        createAlignText();
        createAdvanceX();
        createAdvanceY();
        createSelectionType();
        createSelectAccuracy();
        createWrapWidth();
        createTxtSize();
        */
    }
   //var val: Float = 0.;
    public function tweenExample(){
        //down = changeTextField;
        
        /*
        txt.fx = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            //return px + 5* Math.sin( px );
            //return txt.width/2;
            return px;
        }
        txt.fy = function( px: Float, py: Float, charWid: Float, charHi: Float ){
            return py + 20* Math.sin( ( px + charWid/2 ) * Math.PI/180 );
            //return 3*px + txt.height/2 + txt.y;
        }
        txt.tweenParam = 0.;
        
        //txt.fontStyle.alpha = 1.;
        TweenX.to( this,{ val: 0.5 } ).delay( 0.1 ).time( 3. ).ease( EaseX.backOut ).onUpdate( function(){
            txt.tweenParam = val;
            //txt.fontStyle.alpha = val;
            trace( txt.tweenParam );
        } );
        */

    }
    public static function createAdvanceX(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      null
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  0.
                                    ,   hAlign:     RIGHT
                                    };
        var txtAdvanceX = new SimpleText({ x: 750., y: 200
                            , fontStyle: fontStyle
                            , content: dAdvanceXstr
                            , wrapWidth: 300
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtAdvanceX;
    }
    public static inline
    function createAdvanceY(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      null
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  0.
                                    ,   hAlign:     RIGHT
                                    };
        var txtAdvanceY = new SimpleText({ x: 880., y: 200
                            , fontStyle: fontStyle
                            , content: dAdvanceYstr
                            , wrapWidth: 300
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtAdvanceY;
    }
    public static inline 
    function createAlignText(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      new AbstractRange( { begin: 0, end: 0 } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  20.
                                    ,   hAlign:     CENTRE
                                    };
        var txtAlign = new SimpleText({ x: 550., y: 10.
                            , fontStyle: fontStyle
                            , content: alignStr
                            , wrapWidth: 600
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtAlign;
    }
    public static inline
    function createSelectionType(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      new AbstractRange( { begin: 0, end:0 } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  20.
                                    ,   hAlign:     CENTRE
                                    };
        var txtSelector = new SimpleText({ x: 550., y: 50.
                            , fontStyle: fontStyle
                            , content: selectionStr
                            , wrapWidth: 600
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtSelector;
    }
    public static inline
    function createSelectAccuracy(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      new AbstractRange( { begin: 0, end: 0 } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  20.
                                    ,   hAlign:     CENTRE
                                    };
        var txtAccuracy = new SimpleText({ x: 550., y: 75.
                            , fontStyle: fontStyle
                            , content: accuracyStr
                            , wrapWidth: 600
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtAccuracy;
    }
    public static inline
    function createTxtSize(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      new AbstractRange( { begin: 0, end: 0 } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  2.
                                    ,   hAlign:     CENTRE
                                    };
        var txtSize = new SimpleText({ x: 550., y: 150.
                            , fontStyle: fontStyle
                            , content: textSizeStr
                            , wrapWidth: 450
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtSize;
    }
    public static inline
    function createWrapWidth(){
        var fontStyle: AbstractFontStyle = {   font:       Assets.fonts.Arimo_Regular
                                    ,   size:       20
                                    ,   color:      Color.Blue
                                    ,   alpha:      0.8
                                    ,   range:      new AbstractRange( { begin: 0, end: 0 } )
                                    ,   dAdvanceX:  5.
                                    ,   dAdvanceY:  20.
                                    ,   hAlign:     CENTRE
                                    };
        var txtWrapWidth = new SimpleText({ x: 550., y: 120.
                            , fontStyle: fontStyle
                            , content: wrapWidthStr
                            , wrapWidth: 600
                            , highLightColor: Color.White, highLightAlpha: 0.9
                            , bgHighLightColor: Color.Black, bgHighLightAlpha: 1.
                            , bgColor: Color.White
                            , highLight: true });
        return txtWrapWidth;
    }      
    /*  
    function changeTextField( x: Int, y: Int ){
        var alignment = txtAlign.hitString( x, y, Selection.WORD, Hit.WITHIN, true );
        if( alignment != '' ) { 
            trace( 'alignment change to ' + alignment );
            switch( alignment ){
                case 'LEFT':
                    txt.fontStyle.hAlign = HAlign.LEFT;
                case 'RIGHT':
                    txt.fontStyle.hAlign = HAlign.RIGHT;
                case 'CENTRE':
                    txt.fontStyle.hAlign = HAlign.CENTRE;
                case 'JUSTIFY':
                    txt.fontStyle.hAlign = HAlign.JUSTIFY;
                case _:
                    //
            }
            dirty();
        }
        var selector = txtSelector.hitString( x, y, Selection.WORD, Hit.WITHIN, true );
        if( selector != '' ) { 
            trace( 'selection change to ' + alignment );
            switch( selector ){
                case 'CHARACTER':
                    selection = CHARACTER;
                case 'WORD':
                    selection = WORD;
                case 'LINE':
                    selection = LINE;
                case _:
                    //
            }
            dirty();
        }
        var accuracy = txtAccuracy.hitString( x, y, Selection.WORD, Hit.WITHIN, true );
        if( accuracy != '' ) { 
            trace( 'selection accuracy change to ' + alignment );
            switch( accuracy ){
                case 'WITHIN':
                    accurate = WITHIN;
                case 'CLOSE':
                    accurate = CLOSE;
                case _:
                    //
            }
            dirty();
        }
        var wrapWidth = txtWrapWidth.hitString( x, y, Selection.WORD, Hit.WITHIN, true );
        if( wrapWidth != '' ) { 
            var no = Std.parseFloat( wrapWidth );
            if( !Math.isNaN( no ) ){
                txt.wrapWidth = no;
                dirty();
            } else {
                txtAdvanceX.highLightRange = null;
            }
        }
        var fontSize = txtSize.hitString( x, y, Selection.WORD, Hit.WITHIN, true );
        if( fontSize != '' ) { 
            var no = Std.parseFloat( fontSize );
            if( !Math.isNaN( no ) ){
                txt.fontStyle.size = Std.int( no );
                dirty();
            } else {
                txtAdvanceX.highLightRange = null;
            }
        }

        var dadvancex = txtAdvanceX.hitString( x, y, Selection.LINE, Hit.WITHIN, true );
        if( dadvancex != '' ){
            var no = Std.parseFloat( dadvancex );
            if( !Math.isNaN( no ) ){
                txt.fontStyle.dAdvanceX = no;
                dirty();
            } else {
                txtAdvanceX.highLightRange = null;
            }
        }
        var dadvancey = txtAdvanceY.hitString( x, y, Selection.LINE, Hit.WITHIN, true );
        if( dadvancey != '' ){
            var no = Std.parseFloat( dadvancey );
            if( !Math.isNaN( no ) ){
                txt.fontStyle.dAdvanceY = no;
                dirty();
            } else {
                txtAdvanceY.highLightRange = null;
            }
        }
    }
    */
}