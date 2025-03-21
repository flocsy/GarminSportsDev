import Toybox.Lang;
import Toybox.WatchUi;

class GarminSportsDevDelegate extends WatchUi.BehaviorDelegate {
    var app as GarminSportsDevApp;

    function initialize(app as GarminSportsDevApp) {
        BehaviorDelegate.initialize();
        self.app = app;
    }

    // function onMenu() as Boolean {
    //     app.stopLoop();
    //     WatchUi.pushView(new Rez.Menus.MainMenu(), new GarminSportsDevMenuDelegate(), WatchUi.SLIDE_UP);
    //     return true;
    // }

    function onSelect() as Boolean {
        app.toggleLoop();
        return true;
    }

    function onBack() as Boolean {
        app.stopAndExit();
        return true;
    }

    function onPreviousPage() as Boolean {
        app.speedUp();
        return true;
    }

    function onNextPage() as Boolean {
        app.speedDown();
        return true;
    }

}