package com.fictitious.money.purse.widget;

import android.content.Context;
import android.os.Handler;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.example.ffdemo.R;
import com.fictitious.money.purse.utils.UIUtil;


/**
 *Toast工具类
 */

public class ToastUtil {
    private static Toast toast;
    /**
     * 字体大小
     */
    private final static int FONT_SIZE = 12;

    private final static Context context = UIUtil.getContext();

    public static void showToast(String text) {
        showToast(text, ToastType.NULL, ToastType.LONG);
    }

    public static void showToast(int textId) {
        showToast(textId, ToastType.NULL, ToastType.LONG);
    }

    public static void showToast(int textId, int LONG) {
        showToast(textId, ToastType.NULL, LONG);
    }

    /**
     * @param textId
     * @param imgType
     * @param LONG    0默认2s，1持续时间3.5s
     */
    public static void showToast(int textId, int imgType,
                                 int LONG) {
        String text = context.getResources().getString(textId);
        showToast(text, imgType, LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
    }

    /**
     * @param imgType
     * @param LONG    0默认2s，1持续时间3.5s
     */
    public static void showToast(String text, int imgType,
                                 int LONG) {
        if (context == null) {
            return;
        }
        if (toast == null) {
            toast = new Toast(context);
        }
        show(text, imgType, LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
    }

    public static void show(String text, int imgType, int LONG) {
        LayoutInflater inflater = LayoutInflater.from(context);
        View layout = inflater.inflate(R.layout.customtoast, null);
        ImageView image = (ImageView) layout.findViewById(R.id.warningToast_iv);
        if (imgType == ToastType.RIGHT) {
            image.setImageResource(R.mipmap.icon_right_normal);
        } else if (imgType == ToastType.ERROR) {
            image.setImageResource(R.mipmap.icon_error_normal);
        } else if (imgType == ToastType.WAIT) {

        } else if (imgType == ToastType.NULL) {
            image.setVisibility(View.GONE);
        }
        TextView tView = (TextView) layout.findViewById(R.id.textToast_tv);
        tView.setText(text);
        tView.setTextSize(FONT_SIZE);
        toast.setGravity(Gravity.CENTER, 0, 0);
        toast.setDuration(LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
        toast.setView(layout);
        toast.show();
    }

    /**
     * @param textId
     * @param imgType
     * @param LONG    0默认2s，1持续时间3.5s
     */
    public static void showToast(Handler mHandler,
                                 int textId, final int imgType, final int LONG) {
        if (context == null) {
            return;
        }
        if (toast == null) {
            toast = new Toast(context);
        }
        final String text = context.getResources().getString(textId);
        if (mHandler != null) {
            mHandler.post(new Runnable() {

                @Override
                public void run() {
                    showToast(text, imgType, LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
                }
            });
        }
    }

    /**
     * @param text
     * @param imgType
     * @param LONG    0默认2s，1持续时间3.5s
     */
    public static void showToast(Handler mHandler,
                                 final String text, final int imgType, final int LONG) {
        if (context == null) {
            return;
        }
        if (toast == null) {
            toast = new Toast(context);
        }
        if (mHandler != null) {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    showToast(text, imgType, LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
                }
            });
        }
    }

    private static void showToast(TextView textView, int LONG) {
        if (toast == null) {
            toast = new Toast(context);
        }
        toast.setView(textView);
        toast.setDuration(LONG == 0 ? Toast.LENGTH_SHORT : Toast.LENGTH_LONG);
        toast.show();
    }

    /**
     * 返回的是完整的toast提示，比如提示是"请删除[content]设备"
     *
     * @param context
     * @param id
     * @param content 动态显示的内容
     * @return
     */
    public static String getToastStr(Context context, int id, String content) {
        String str = context.getResources().getString(id);
        return String.format(str, content);
    }

    /**
     * 消失提示
     */
    public static void dismissToast() {
        if (toast != null) {
            toast.cancel();
        }
    }

    /**
     * 在UI线程中消失
     *
     * @param mHandler
     */
    public static void dismiss(Handler mHandler) {
        if (mHandler != null) {
            mHandler.post(new Runnable() {

                @Override
                public void run() {
                    if (toast != null) {
                        toast.cancel();
                    }
                }
            });
        }
    }
}
