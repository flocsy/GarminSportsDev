import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GarminSportsDevView extends WatchUi.View {
    var app as GarminSportsDevApp;
    var logo as BitmapResource;

    function initialize(app as GarminSportsDevApp) {
        View.initialize();
        self.app = app;
        self.logo = WatchUi.loadResource(Rez.Drawables.sports) as BitmapResource;
    }

    function onUpdate(dc as Dc) as Void {
        var name = getSportName(app.sport, app.subSport);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();
        dc.drawBitmap((dc.getWidth() - logo.getWidth()) / 2, 0, logo);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_TINY,
            "sport: " + app.sport + "\nsubSport: " + app.subSport + "\n" + name,
            Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        dc.drawText(dc.getWidth()/2, dc.getHeight() - dc.getFontHeight(Graphics.FONT_TINY) - 10, Graphics.FONT_TINY, "speed: " + (9 - app.speedIdx), Graphics.TEXT_JUSTIFY_CENTER);

        if (!app.loop) {
            var statusIcon = new Rez.Drawables.stop() as Drawable;
			statusIcon.draw(dc);
        }
    }
}
