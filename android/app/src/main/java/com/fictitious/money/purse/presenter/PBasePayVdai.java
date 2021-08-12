package com.fictitious.money.purse.presenter;

import android.app.Dialog;

import com.example.ffdemo.R;
import com.fictitious.money.purse.listener.OnCompleteDataListener;
import com.fictitious.money.purse.model.MBasePayVdai;
import com.fictitious.money.purse.model.MinerFeeBean;
import com.fictitious.money.purse.web.vdai.BasePayVdaiActivity;
import com.fictitious.money.purse.widget.DialogUitl;

import cn.droidlover.xdroidmvp.mvp.XPresent;
import cn.droidlover.xdroidmvp.net.NetError;

/**
 * Copyright (C), 2015-2019, 深圳新明华区块链技术有限公司
 * Author: ouyonghua
 * Date: 2019-11-14 09:59
 * Description:
 */
public class PBasePayVdai extends XPresent<BasePayVdaiActivity> {

    private final MBasePayVdai mBasePayVdai;

    public PBasePayVdai() {
        mBasePayVdai = new MBasePayVdai();
    }

    public void getVnsTransInfo(String token, String from, String contract) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            dialog.show();
            mBasePayVdai.getVnsTransInfo(token, from, contract, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().showMinersFeeView((MinerFeeBean) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                    }
                }
            });

        }
    }

    public void paySaveVns(String token, String vnsAddress, String vnsJoinContractAddress, String vnsNum, String vusdNum, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.paySaveVns(token, vnsAddress, vnsJoinContractAddress, vnsNum, vusdNum, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payCreateCDP(String token, String vnsAddress, String vnsJoinContractAddress, String vnsNum, String vusdNum, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payCreateCDP(false, token, vnsAddress, vnsJoinContractAddress, vnsNum, vusdNum, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payGetVns(String token, String vnsAddress, String vnsJoinContractAddress, String vnsNum, String vusdNum, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payGetVns(token, vnsAddress, vnsJoinContractAddress, vnsNum, vusdNum, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payRepayVusd(String token, String vnsAddress, String vnsJoinContractAddress, String vnsNum, String vusdNum, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payRepayVusd(false, token, vnsAddress, vnsJoinContractAddress, vnsNum, vusdNum, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payGenerateVusd(String token, String vnsAddress, String vnsJoinContractAddress, String vusdNum, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payGenerateVusd(token, vnsAddress, vnsJoinContractAddress, vusdNum, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payTransferVusd(String token, String vnsAddress, String vnsJoinContractAddress, String transferVusdAddreess, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payTransferVusd(false, token, vnsAddress, vnsJoinContractAddress, transferVusdAddreess, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payAccept(String token, String vnsAddress, String vnsJoinContractAddress, String transferVusdAddreess, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payAccept(false, token, vnsAddress, vnsJoinContractAddress, transferVusdAddreess, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void payCloseVusd(String vnsAddress, String vnsJoinContractAddress, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.payCloseVusd(false, vnsAddress, vnsJoinContractAddress, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }

    public void paySend(boolean isToken, String token, String fromAddress, String toAddress, String contract, String money, String decimals, byte[] signPrvKey) {
        if (hasV()) {
            Dialog dialog = DialogUitl.loadingDialog(getV(), getV().getString(R.string.tv_please_wait));
            mBasePayVdai.paySend(isToken, token, fromAddress, toAddress, contract, money, decimals, signPrvKey, new OnCompleteDataListener() {
                @Override
                public void onComplete(Object result) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackSuccessful((String) result);
                    }
                }

                @Override
                public void onFailure(NetError error) {
                    if (hasV()) {
                        dialog.dismiss();
                        getV().callbackFailed(error);
                    }
                }
            });
        }
    }


}
