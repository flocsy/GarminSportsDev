import Toybox.Activity;
import Toybox.ActivityRecording;
import Toybox.Application;
import Toybox.FitContributor;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Timer;
import Toybox.WatchUi;

class GarminSportsDevApp extends Application.AppBase {
    var timer as Timer.Timer;
    var view as GarminSportsDevView;
    var session as Session?;
    var loop as Boolean = false;
    var speedIdx as Number = 5;
    var speedMs as Number = 1024;
    var exit as Boolean = false;
    var save as Boolean = false;
    var sport as Number = 0;
    var subSport as Number = 0;
    var crashed as Boolean = false;

    function initialize() {
        AppBase.initialize();
        timer = new Timer.Timer();
        view = new GarminSportsDevView(self);
    }

    function onStart(state as Dictionary?) as Void {
        log("onStart");
        self.crashed = getConfigBoolean("crashed");
        readConfig();
        if (self.crashed) {
            nextSport();
        }
    }

    function readConfig() as Void {
        log("readConfig");
        self.loop = false;
        self.sport = getConfigNumber("sport");
        self.subSport = getConfigNumber("subSport");
        self.save = getConfigBoolean("save");
        log(
            "lastSuccesfulSport: " + getConfigNumber("lastSuccesfulSport") +
            ", lastSuccesfulSubSport: " + getConfigNumber("lastSuccesfulSubSport") +
            ", sport: " + self.sport + ", subSport: " + self.subSport + ", crashed: " + getConfigBoolean("crashed")
        );
    }

    function onSettingsChanged() as Void {
        log("onSettingsChanged");
        readConfig();
        self.crashed = false;
        setConfig("crashed", false);
        self.loop = false;
        WatchUi.requestUpdate();
    }

    function getInitialView() as [Views] or [Views, InputDelegates] {
        log("getInitialView");
        return [view, new GarminSportsDevDelegate(self)];
    }

    function nextSport() as Void {
        // log("nextSport");
        var sport = self.sport;
        var subSport = self.subSport;
        if (self.crashed) {
            subSport = MAX_SUB_SPORT;
        }
        subSport += 1;
        if (subSport > MAX_SUB_SPORT) {
            sport++;
            subSport = 0;
        }
        self.sport = sport;
        self.subSport = subSport;
        setConfig("sport", sport);
        setConfig("subSport", subSport);
        if (sport > MAX_SPORT) {
            loop = false;
            WatchUi.pushView(new FinishedView(), null, WatchUi.SLIDE_RIGHT);
        } else {
            WatchUi.requestUpdate();
        }
    }

    function startSession() as Void {
        var sport = self.sport;
        var subSport = self.subSport;
        var name = getSportName(sport, subSport);
        log("startSession: sport: " + sport.format("%3d") + ", subSport: " + subSport.format("%3d") + ": " + name);
        setConfig("crashed", true);
        // saveProperties();
        var session = ActivityRecording.createSession({
            :name => "" + sport + ":" + subSport + " " + name,
            :sport => sport as Activity.Sport,
            :subSport => subSport as Activity.SubSport,
        });
        session.createField("sport", 0, FitContributor.DATA_TYPE_UINT8, {:mesgType => FitContributor.MESG_TYPE_SESSION, :units => ""})
            .setData(sport);
        session.createField("subSport", 1, FitContributor.DATA_TYPE_UINT8, {:mesgType => FitContributor.MESG_TYPE_SESSION, :units => ""})
            .setData(subSport);
        session.start();
        self.session = session;
        // if (Activity has :getProfileInfo) {
        //     var profileInfo = Activity.getProfileInfo();
        //     var _sport = profileInfo.sport;
        //     if (_sport != null) {
        //         _sport = _sport.format("%3d");
        //     }
        //     var _subSport = profileInfo.subSport;
        //     if (_subSport != null) {
        //         _subSport = _subSport.format("%3d");
        //     }
        //     log("profileInfo: sport: " + _sport + ", subSport: " + _subSport + ": " + profileInfo.name
        //         + ", uniqueIdentifier: " + profileInfo.uniqueIdentifier);
        // }
        timer.start(method(:stopSession), speedMs, false);
    }

    function stopSession() as Void {
        log("stopSession");
        var session = self.session;
        if (session != null) {
            session.stop();
            if (save) {
                session.save();
            } else {
                session.discard();
            }
            self.session = null;
            self.crashed = false;
            setConfig("crashed", false);
            setConfig("lastSuccesfulSport", self.sport);
            setConfig("lastSuccesfulSubSport", self.subSport);
            nextSport();
        }
        if (exit) {
            System.exit();
        }
        if (loop) {
            timer.start(method(:startSession), 50, false);
        }
    }

    function startLoop() as Void {
        if (!loop) {
            log("startLoop");
            loop = true;
            startSession();
            WatchUi.requestUpdate();
        }
    }

    function stopLoop() as Void {
        log("stopLoop");
        timer.stop();
        if (loop) {
            loop = false;
            stopSession();
            WatchUi.requestUpdate();
        }
    }

    function toggleLoop() as Void {
        if (loop) {
            stopLoop();
        } else {
            startLoop();
        }
    }

    function setSpeed(speedIdx as Number) as Void {
        self.speedIdx = speedIdx;
        self.speedMs = 32 << speedIdx;
        log("setSpeed: " + speedIdx + " => " + self.speedMs + "ms");
    }

    function speedUp() as Void {
        if (speedIdx > 1) {
            setSpeed(speedIdx - 1);
        }
    }

    function speedDown() as Void {
        if (speedIdx < 8) {
            setSpeed(speedIdx + 1);
        }
    }

    function stopAndExit() as Void {
        log("stopAndExit");
        if (loop) {
            exit = true;
            stopLoop();
        } else {
            System.exit();
        }
    }

    function onStop(state as Dictionary?) as Void {
        log("onStop");
        timer.stop();
    }
}

function getSportName(sport as Number, subSport as Number) as String {
    var name = SPORT_NAMES[sport * 1000 + subSport];
    if (name == null) {
        name = "?";
    }
    return name;
}
