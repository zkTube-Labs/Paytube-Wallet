package cn.droidlover.xdroidmvp.rxbus;

import cn.droidlover.xdroidmvp.event.IBus;

public class ResponseEvent implements IBus.IEvent{
    public String message;

    public ResponseEvent(String msg)
    {
        message = msg;
    }

    @Override
    public int getTag() {
        return 0;
    }
}
