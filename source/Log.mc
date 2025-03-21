import Toybox.Ant;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;

// types:
typedef AlphaNumeric as String or Number;

(:release, :inline)
function log(msg as String) as Void {}
(:debug, :inline)
function log(msg as String) as Void {
    if (LOG) {
        logRelease(msg);
    }
}

(:release, :inline)
function logIf(isEnabled as Boolean, msg as String?) as Void  {}
(:debug, :inline)
function logIf(isEnabled as Boolean, msg as String?) as Void  {
    if (isEnabled) {
        logRelease(msg);
    }
}

(:release, :inline)
function logDebug(msg as String?) as Void {}
(:debug, :inline)
function logDebug(msg as String?) as Void {
    logRelease(msg);
}

function logRelease(msg as String?) as Void {
    // System.println(Time.now().value() + " " + msg);
    var time = timeFormat(Time.now());
    System.println(time + " " + msg);
}

(:inline)
function errorRelease(msg as String?) as Void {
    // var time = timeFormat(Time.now());
    // System.error(time + " " + msg);
    logRelease(msg);
}

// (:memory16Kminus, :inline)
// function timeFormat(moment as Moment) as AlphaNumeric {
//     return moment.value();
// }
(:memory16Kplus, :no_inline)
function timeFormat(moment as Moment) as AlphaNumeric {
    var time = Time.Gregorian.info(moment, Time.FORMAT_SHORT);
    // var time = System.getClockTime(); // -13
    // return "" + time.hour + ':' + time.min + ':' + time.sec;
    var format = "%02d";
    return time.hour.format(format) + ':' + time.min.format(format) + ':' + time.sec.format(format);
    // var ms = System.getTimer() % 1000;
    // return "" + time.hour.format(format) + ':' + time.min.format(format) + ':' + time.sec.format(format) + "." + ms.format("%03d");
}

// (:memory16Kminus, :inline)
// function timestampFormat(timestamp as Number) as AlphaNumeric {
//     return timestamp;
// }
(:memory16Kplus, :inline)
function timestampFormat(timestamp as Number) as AlphaNumeric {
    return timeFormat(new Time.Moment(timestamp));
}
