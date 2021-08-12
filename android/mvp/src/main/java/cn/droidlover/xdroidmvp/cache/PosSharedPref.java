package cn.droidlover.xdroidmvp.cache;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * pos机的缓存
 */

public class PosSharedPref implements ICache {

    private static SharedPreferences sharedPreferences;
    private static SharedPreferences.Editor editor;

    static final String SP_NAME = "poscache";

    private static PosSharedPref instance;

    private PosSharedPref(Context context) {
        sharedPreferences = context.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
        editor = sharedPreferences.edit();
    }

    public static PosSharedPref getInstance(Context context) {
        if (instance == null) {
            synchronized (PosSharedPref.class) {
                if (instance == null) {
                    instance = new PosSharedPref(context.getApplicationContext());
                }
            }
        }
        return instance;
    }

    @Override
    public void remove(String key) {
        editor.remove(key);
        editor.apply();
    }


    @Override
    public boolean contains(String key) {
        return sharedPreferences.contains(key);
    }

    @Override
    public void clear() {
        editor.clear().apply();
    }


    public void putInt(String key, int value) {
        editor.putInt(key, value);
        editor.apply();
    }

    public int getInt(String key, int defValue) {
        return sharedPreferences.getInt(key, defValue);
    }

    public void putLong(String key, Long value) {
        editor.putLong(key, value);
        editor.apply();
    }

    public long getLong(String key, long defValue) {
        return sharedPreferences.getLong(key, defValue);
    }


    public void putBoolean(String key, Boolean value) {
        editor.putBoolean(key, value);
        editor.apply();
    }

    public boolean getBoolean(String key, boolean defValue) {
        return sharedPreferences.getBoolean(key, defValue);
    }


    public void putString(String key, String value) {
        editor.putString(key, value);
        editor.apply();
    }

    public String getString(String key, String defValue) {
        return sharedPreferences.getString(key, defValue);
    }

    @Override
    public Object get(String key) {
        return null;
    }

    @Override
    public void put(String key, Object value) {

    }
}
