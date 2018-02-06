package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Image;
import kha.Assets;
import kha.System;
import kha.FastFloat;
import tweenx909.TweenX;
import tweenx909.EaseX;
import simpleText.SimpleText;
import kha.graphics4.TextureFormat;
import kha.graphics4.DepthStencilFormat; 
import kha.Font;
import westCountrySalsa.LatinoSundays;
class FontTest {

    public function new() {
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        setup();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
    }
    var img: Image;

    var txt: SimpleText;

    public function setup(){
        var latinoSundays = new LatinoSundays();
        txt = latinoSundays.txt;
        var txt_ = txt;
        var scalableText = new ScalableText( txt );
        var targetHeight = scalableText.getScaleForHeight( 300 );
        TweenX.to( scalableText, { scale: targetHeight }).delay( 0.5 ).time( 1.2 ).onFinish(function(){
            trace( txt.height );
        });
    }
    function dimensions( char: String, font: Font, size: Int ):{ width: Float, height: Float }{
        return { height: font.height( size ), width: font.width( size, char ) };
    }
    var val: Float = 0.;
    var widT: Float;
    var hiT: Float;
    function update(): Void {
    }
    function render( framebuffer: Framebuffer ):Void {
        var g2 = framebuffer.g2;
        g2.begin();
        g2.clear( Color.fromValue( 0xff9B7031 ) );
        g2.color = Color.White;
        g2.opacity = 1.;
        txt.render( g2 );
        g2.end();
    }
}