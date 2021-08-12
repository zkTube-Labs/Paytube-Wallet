package com.fictitious.money.purse.widget;

import android.app.Dialog;
import android.content.Context;
import android.view.View;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;
import com.example.ffdemo.R;
import com.fictitious.money.purse.utils.KeyBoardUtils;
import com.fictitious.money.purse.utils.Sha;

import java.security.NoSuchAlgorithmException;


/**
 * Created by cxf on 2017/8/8.
 */

public class DialogUitl {
    public static Dialog inputDialog(Context context, String title, String confirmText, String cancelText, final Callback3 callback) {
        final Dialog dialog = new Dialog(context, R.style.inputDialog);
        dialog.setContentView(R.layout.dialog_input);
        dialog.setCancelable(true);
        dialog.setCanceledOnTouchOutside(true);
        TextView titleView = (TextView) dialog.findViewById(R.id.title);
        titleView.setText(title);
        final EditText input = (EditText) dialog.findViewById(R.id.input);
        TextView cancelBtn = (TextView) dialog.findViewById(R.id.cancel_btn);
        if (!"".equals(cancelText)) {
            cancelBtn.setText(cancelText);
        }
        TextView confirmBtn = (TextView) dialog.findViewById(R.id.confirm_btn);
        if (!"".equals(confirmText)) {
            confirmBtn.setText(confirmText);
        }
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.cancel_btn:
                        dialog.dismiss();
                        break;
                    case R.id.confirm_btn:
                        if (callback != null) {
                            String text = input.getText().toString();
                            callback.confirm(dialog, text);
                        }
                        break;
                }
            }
        };
        cancelBtn.setOnClickListener(listener);
        confirmBtn.setOnClickListener(listener);
        return dialog;
    }

    public static Dialog inputDialog(Context context, String title, String confirmText, String cancelText, boolean cancel, final Callback4 callback) {
        final Dialog dialog = new Dialog(context, R.style.inputDialog);
        dialog.setContentView(R.layout.dialog_input);
        dialog.setCancelable(cancel);
        dialog.setCanceledOnTouchOutside(cancel);
        TextView titleView = (TextView) dialog.findViewById(R.id.title);
        titleView.setText(title);
        final EditText input = (EditText) dialog.findViewById(R.id.input);
        TextView cancelBtn = (TextView) dialog.findViewById(R.id.cancel_btn);
        if (!"".equals(cancelText)) {
            cancelBtn.setText(cancelText);
        }
        TextView confirmBtn = (TextView) dialog.findViewById(R.id.confirm_btn);
        if (!"".equals(confirmText)) {
            confirmBtn.setText(confirmText);
        }
        View.OnClickListener listener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                switch (v.getId()) {
                    case R.id.cancel_btn:
                        // 收起输入键盘
                        KeyBoardUtils.hideKeyBoard(context,dialog);
                        if (callback != null) {
                            callback.cancel(dialog);
                            input.setText("");
                        }
                        break;
                    case R.id.confirm_btn:
                        if (callback != null) {
                            // 收起输入键盘
                            KeyBoardUtils.hideKeyBoard(context,dialog);
                            String text = "";
                            try {
                                text = Sha.getSHA(input.getText().toString());
                            } catch (NoSuchAlgorithmException e) {
                                e.printStackTrace();
                            }
                            callback.confirm(dialog, input.getText().toString(), text);
                            input.setText("");
                        }
                        break;
                }
            }
        };
        cancelBtn.setOnClickListener(listener);
        confirmBtn.setOnClickListener(listener);
        return dialog;
    }

    public static Dialog loadingDialog(Context context, String text) {
        Dialog loadingDialog = new Dialog(context, R.style.dialog);
        loadingDialog.setContentView(R.layout.dialog_system_loading);
        loadingDialog.setCancelable(true);
        loadingDialog.setCanceledOnTouchOutside(true);//点击空白处消失
        if (!"".equals(text)) {
            TextView titleView = (TextView) loadingDialog.findViewById(R.id.text);
            titleView.setText(text);
        }
        ImageView img = (ImageView) loadingDialog.findViewById(R.id.img);
        Glide.with(context).load(R.drawable.loading2).asGif().into(img);
        return loadingDialog;
    }

    public static Dialog messageDialog(Context context, String title, String message, String confirmText, final Callback2 callback) {
        final Dialog dialog = new Dialog(context, R.style.dialog);
        dialog.setContentView(R.layout.dialog_message);
        dialog.setCancelable(true);
        dialog.setCanceledOnTouchOutside(true);
        TextView titleView = (TextView) dialog.findViewById(R.id.title);
        titleView.setText(title);
        TextView content = (TextView) dialog.findViewById(R.id.content);
        content.setText(message);
        TextView confirmBtn = (TextView) dialog.findViewById(R.id.confirm_btn);
        if (!"".equals(confirmText)) {
            confirmBtn.setText(confirmText);
        }
        confirmBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                dialog.dismiss();
                if (callback != null) {
                    callback.confirm(dialog);
                }
            }
        });
        return dialog;
    }

    public interface Callback2 {
        void confirm(Dialog dialog);
    }

    public interface Callback3 {
        void confirm(Dialog dialog, String text);
    }

    public interface Callback4 {
        void confirm(Dialog dialog, String text, String sha);
        void cancel(Dialog dialog);
    }
}
