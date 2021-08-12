package com.fictitious.money.purse.results;

import cn.droidlover.xdroidmvp.net.IModel;

/**
 * Created by wanglei on 2016/12/11.
 */

public class BaseModel implements IModel {

    @Override
    public boolean isNull() {
        return false;
    }

    @Override
    public boolean isAuthError() {
        return false;
    }

    @Override
    public boolean isBizError() {
        return false;
    }

    @Override
    public String getErrorMsg() {
        return null;
    }
}
