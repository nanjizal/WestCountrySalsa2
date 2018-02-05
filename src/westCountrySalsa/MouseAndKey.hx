package westCountrySalsa;
import kha.input.Keyboard;
import kha.input.KeyCode;
import kha.input.Mouse;
import kha.input.KeyCode;
import simpleText.SimpleText;
class MouseAndKey {
    public var txt:         SimpleText;
    public var change:      Int->Int->Void;
    public var down:        Int->Int->Void;
    public var up:          Int->Int->Void;
    public var rightDown:   Int->Int->Void;
    public var rightUp:     Int->Int->Void;
    public var enable:      Bool = true;
    // ??
    public var x: Int = -1;
    public var y: Int = -1;
    public function new(){
        Keyboard.get().notify( keyDown, keyUp, pressListener );
        Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null, null );// wheelListener, leaveListener );
    }
    public function onMouseDown( button: Int, x: Int, y: Int ): Void {
        if( !enable ) return;
        if( button == 0 && down      != null ) down( x, y );
        if (button == 1 && rightDown != null ) rightDown( x, y );
    }
    public function onMouseUp( button: Int, x: Int, y: Int ): Void {
        //trace('mouse button UP');
        if( !enable ) return;
        if (button == 0 && up != null ) up( x, y );
        if (button == 1 && rightUp != null ) rightUp( x, y );
    }
    public function onMouseMove( x: Int, y: Int, cx: Int, cy: Int ): Void {
        if( !enable ) return;
        if( x > 0 && y > 0 && change != null ) change( x, y );
    }
    var key: Int;
    function keyDown( keyCode: Int ):Void{
        key = keyCode;
        if( !enable ) return;
        switch( keyCode ){
            case 8:
                if( txt != null ){
                    txt.content = txt.content.substr( 0,txt.content.length-2 );
                    txt.dirty = true;
                }
            case _:
                //
        }
    }
    function keyUp( keyCode: Int  ):Void{ 
        if( !enable ) return;
        trace( keyCode );
    }
    function pressListener( str: String ){
        trace( 'pressed ' + str + key );
        if( txt != null ){
            txt.content += str;
            txt.dirty = true;
            //dirty();
        }
    }
}