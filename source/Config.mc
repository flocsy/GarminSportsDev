import Toybox.Application;
import Toybox.Application.Properties;
import Toybox.Lang;

(:no_properties, :no_ciq_2_4_0, :inline) // NOTE: forbidden to set properties in background
function setConfig(key as PropertyKeyType, val as PropertyValueType) as Void {
    Application.getApp().setProperty(key, val);
}
(:properties, :ciq_2_4_0, :inline) // NOTE: forbidden to set properties in background
function setConfig(key as PropertyKeyType, val as PropertyValueType) as Void {
    Properties.setValue(key, val);
}

(:no_properties, :no_ciq_2_4_0, :inline)
function getConfig(key as PropertyKeyType) as PropertyValueType or Null {
    var val;
    try {
        val = Application.getApp().getProperty(key);
    } catch (e) {
        if (LOG) {
            log(key + ":" + e.getErrorMessage());
        }
        val = null;
    }
    return val;
}
(:properties, :ciq_2_4_0, :inline)
function getConfig(key as PropertyKeyType) as PropertyValueType or Null {
    var val;
    try {
        val = Properties.getValue(key);
    } catch (e) {
        if (LOG) {
            log(key + ":" + e.getErrorMessage());
        }
        val = null;
    }
    return val;
}

function getConfigNumber(key as String) as Number {
    return ifNullThenZero(getConfig(key) as Number?) as Number;
}

function getConfigBoolean(key as String) as Boolean {
    return getConfig(key) as Boolean == true;
}

function ifNullThenZero(val as Number or Float or Null) as Number or Float {
    return val != null ? val : 0;
}
