import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_coinid/channel/channel_native.dart';
import 'package:flutter_coinid/channel/channel_scan.dart';
import 'package:flutter_coinid/models/contacts/contact_address.dart';
import 'package:flutter_coinid/models/tokens/collection_tokens.dart';
import 'package:flutter_coinid/models/transrecord/trans_record.dart';
import 'package:flutter_coinid/models/wallet/mh_wallet.dart';
import 'package:flutter_coinid/models/wallet/sign/ethsignparams.dart';
import 'package:flutter_coinid/net/chain_services.dart';
import 'package:flutter_coinid/pages/main/payment_sheet_page.dart';
import 'package:flutter_coinid/pages/main/wallets_managet_tokens.dart';
import 'package:flutter_coinid/utils/json_util.dart';
import 'package:flutter_coinid/utils/sharedPrefer.dart';
import 'package:flutter_coinid/widgets/custom_alert.dart';
import '../../public.dart';

const btcDefaultSatLen = "500";

class TransParams {
  final dynamic transParams;
  final String? amount;
  final String to;
  final String? from;
  final String? fee;
  TransParams(this.transParams, this.amount, this.to, this.from, this.fee);
}

class PaymentPage extends StatefulWidget {
  PaymentPage({Key? key, this.params}) : super(key: key);
  Map? params = Map();

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _addressEC = TextEditingController();
  TextEditingController _valueEC = TextEditingController();
  TextEditingController _remarkEC = TextEditingController();
  TextEditingController _customFeeEC = TextEditingController();
  String remarkText = ""; //备注
  EdgeInsets padding = EdgeInsets.only(
      left: OffsetWidget.setSc(26), right: OffsetWidget.setSc(26), top: 0);
  double? _balanceNum = 0;
  dynamic chaininfo;
  int _feeOffset = 20; //gas or sat
  double? _feeValue = 0.0;
  bool _isCustomFee = false; //是否自定义矿工费
  double? tokenPrice = 0;
  double sliderMin = 0;
  double sliderMax = 100;
  MHWallet? _wallet;
  bool hiddenTokens = false;
  bool allTrans = false;
  @override
  void initState() {
    super.initState();
    if (widget.params != null) {
      if (widget.params!.containsKey("to")) {
        _addressEC.text = widget.params!["to"][0];
      }
      if (widget.params!.containsKey("hiddenTokens")) {
        hiddenTokens =
            true.toString() == widget.params!["hiddenTokens"][0] ? true : false;
      }
    }
    if (Constant.inProduction == false) {
      _addressEC.text = "0xC38c4bB7EBb36142C25fDD124b6f888614922Af9";
    }
    _initData(() {});
  }

  _initData(VoidCallback back) async {
    _wallet = Provider.of<CurrentChooseWalletState>(context, listen: false)
        .currentWallet;
    MCollectionTokens? tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens;
    MCurrencyType? amountType =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currencyType;
    assert(_wallet != null, "钱包数据为空");
    if (_wallet == null) return;

    tokenPrice = tokens?.price?.toDouble() ?? 0;
    _balanceNum = tokens?.balance?.toDouble() ?? 0;
    int? chainType = _wallet?.chainType;
    String? contract = tokens?.contract;
    String? token = tokens?.token;
    int? decimal = tokens?.decimals;
    if (chainType == MCoinType.MCoinType_ETH.index) {
      sliderMax = 150;
      sliderMin = 1;
    } else {
      sliderMax = 135;
      sliderMin = 6;
    }
    String? from = _wallet?.walletAaddress;
    ChainServices.requestAssets(
        chainType: chainType,
        from: from,
        contract: contract,
        token: token,
        tokenDecimal: decimal,
        block: (result, code) {
          if (code == 200 && result is MainAssetResult && mounted) {
            String? balance = result.c;
            balance ??= "0";
            setState(() {
              _balanceNum = double.tryParse(balance!);
            });
            LogUtil.v("requestAssets" + result.toString());
            setState(() {
              _balanceNum = double.tryParse(balance!);
            });
          }
        });
    ChainServices.requestChainInfo(
        chainType: chainType,
        from: from,
        amount: "",
        m: 1,
        n: 1,
        contract: contract,
        block: (result, code) {
          String newBean = btcDefaultSatLen;
          int offset = _feeOffset;
          if (code == 200 && result != null) {
            chaininfo = result;
            if (chainType == MCoinType.MCoinType_ETH.index) {
              String gasPrice = chaininfo["p"] ??= "0";
              int gasFee = int.tryParse(gasPrice)! ~/ pow(10, 9);
              int minv = max(sliderMin.toInt(), gasFee);
              gasFee = min(sliderMax.toInt(), minv);
              offset = gasFee;
              newBean = chaininfo["g"] ??= "0";
            }
          }
          String value = MHWallet.configFeeValue(
              cointype: chainType,
              beanValue: newBean,
              offsetValue: offset.toString());
          if (mounted) {
            setState(() {
              _feeValue = double.tryParse(value);
              _feeOffset = offset;
            });
          }

          if (back != null) {
            back();
          }
        });
  }

  _startScanAddress() async {
    FocusScope.of(context).requestFocus(FocusNode());
    String? result = await (ChannelScan.scan());
    if (result?.isValid() == true && mounted) {
      setState(() {
        _addressEC.text = result ??= "";
      });
    }
  }

  _remarkStringChange(String value) {
    setState(() {
      remarkText = value;
    });
  }

  _customfeeChange(String value) {
    MHWallet _wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    if (_wallet.chainType == MCoinType.MCoinType_ETH.index) {
      if (chaininfo == null) {
        return;
      }
      if (value.isValid() == false) {
        value = "0";
      }
      int fee =
          _feeValue! * pow(10, 9) ~/ int.tryParse((chaininfo["g"] as String))!;
      int minv = max(sliderMin.toInt(), fee);
      int a = min(sliderMax.toInt(), minv);
      setState(() {
        _feeValue = double.tryParse(value);
        _feeOffset = a;
      });
      LogUtil.v("_customfeeChange $value   a $_feeOffset");
    }
  }

  _sliderChange(double value) {
    MHWallet? _wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet;
    int? chainType = _wallet?.chainType;
    String bean = btcDefaultSatLen;
    setState(() {
      _feeOffset = value.toInt();
    });
    LogUtil.v("chaininfo $chaininfo change $value");
    if (chainType == MCoinType.MCoinType_ETH.index) {
      bean = chaininfo["g"] ??= "0";
    }
    LogUtil.v("slider change $value");
    String newfee = MHWallet.configFeeValue(
        cointype: chainType,
        beanValue: bean.toString(),
        offsetValue: _feeOffset.toString());
    setState(() {
      _feeValue = double.tryParse(newfee);
    });
  }

  void _updateFeeWidget() {
    setState(() {
      _isCustomFee = !_isCustomFee;
    });
  }

  void tapSelectToken() {
    showModalBottomSheet(
        context: context,
        backgroundColor: ColorUtils.rgba(40, 33, 84, 1),
        elevation: 0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return SafeArea(child: WalletsTokensPage(
            back: () {
              setState(() {});
              _initData(() {});
            },
          ));
        });
  }

  void _popupInfo() async {
    FocusScope.of(context).requestFocus(FocusNode());
    MHWallet _wallet =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currentWallet!;
    MCollectionTokens tokens =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens!;

    bool isToken = tokens.isToken;
    int decimals = tokens.decimals ?? 0;
    String? contract = tokens.contract;
    //合法性判断
    //余额判断
    //地址判断
    //蓝牙是否连接
    //是否给自己转账
    //余额加矿工费
    //点击全部时余额判断关掉
    String to = _addressEC.text.trim();
    String? from = _wallet.walletAaddress;
    String value = _valueEC.text.trim();
    String gas = "";
    int? coinType = _wallet.chainType;
    bool? isValid = false;
    if (to.length == 0) {
      HWToast.showText(text: "input_paymentaddress".local());
      return;
    }
    try {
      isValid = await (ChannelNative.checkAddressValid(coinType, to));
    } catch (e) {
      LogUtil.v("校验失败" + e.toString());
    }
    if (isValid == false) {
      HWToast.showText(text: "input_addressinvalid".local());
      return;
    }
    if (value.length == 0) {
      HWToast.showText(text: "input_paymentvalue".local());
      return;
    }
    if (double.parse(value) == 0) {
      HWToast.showText(text: "input_paymentvaluezero".local());
      return;
    }
    //判断余额是否充足
    if (double.tryParse(value)! > _balanceNum!) {
      HWToast.showText(text: "payment_valueshouldlessbal".local());
      return;
    }
    // if (from == to) {
    //   HWToast.showText(text: "input_paymentself".local());
    //   return;
    // }
    //判断代币decimal
    if (isToken == true && decimals == 0) {
      HWToast.showText(text: "payment_decimalinvalid".local());
      return;
    }

    if (chaininfo == null) {
      //重新获取数据
      _initData(() {
        if (chaininfo == null) {
          HWToast.showText(text: "request_state_failere".local());
          return;
        }
        _popupInfo();
      });
      return;
    }

    String feeValue = "0";
    if (coinType == MCoinType.MCoinType_ETH.index) {
      feeValue = MHWallet.configFeeValue(
        cointype: coinType,
        beanValue: chaininfo["g"] as String?,
        offsetValue: _feeOffset.toString(),
      );
      if (double.parse(feeValue) == 0) {
        HWToast.showText(text: "payment_highfee".local());
        return;
      }
      if (allTrans == true) {
        value = (_balanceNum! - double.parse(feeValue)).toString();
      } else {
        if (double.parse(feeValue) + double.tryParse(value)! >
            _balanceNum!.toDouble()) {
          HWToast.showText(text: "payment_valueshouldlessbal".local());
          return;
        }
      }

      MSignType signType = MSignType.MSignType_Main;
      if (isToken == true) {
        signType = MSignType.MSignType_Token;
      }
      ETHSignParams ethsign = ETHSignParams(
          chaininfo["n"],
          _feeOffset.toString(),
          chaininfo["g"],
          null,
          chaininfo["v"],
          decimals,
          contract,
          signType);
      _showSheetView(amount: value, fee: feeValue, transParams: ethsign);
    }
  }

  void _tapTransAllAmount() {
    _valueEC.text = _balanceNum.toString();
    allTrans = true;
  }

  ///重新计算后的转账金额，手续费，筛选后的utxo
  _showSheetView({String? amount, String? fee, dynamic transParams}) async {
    String? from = _wallet!.walletAaddress;
    String to = _addressEC.text.trim();
    String remark = _remarkEC.text.trim();
    //弹出sheet
    showModalBottomSheet(
        context: context,
        backgroundColor: Color(0XFF252351),
        elevation: 0,
        isDismissible: true,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        builder: (context) {
          return SafeArea(
            child: PaymentSheet(
              datas: PaymentSheet.getTransStyleList(
                  from: from, amount: amount, to: to, remark: remark, fee: fee),
              nextAction: () {
                _unLockWallet(
                    amount: amount, transParams: transParams, fee: fee);
              },
            ),
          );
        });
  }

  ///解锁
  _unLockWallet({String? amount, dynamic transParams, fee}) async {
    String to = _addressEC.text.trim();
    String? from = _wallet!.walletAaddress;

    ShowCustomAlert.showCustomAlertType(context,
        alertType: AlertType.password,
        title: "dialog_pwd".local(),
        rightButtonColor: ColorUtils.fromHex("#FD5852"),
        confirmPressed: (map) async {
      String value = map['text']!;
      TransParams params = TransParams(
        transParams,
        amount,
        to,
        from,
        fee,
      );
      //构造参数
      _startSign(params, value);
    });
  }

  ///开始签名
  _startSign(TransParams params, String? pin) async {
    String? token =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .chooseTokens
            ?.token;
    int chainID = Provider.of<MNodeState>(context, listen: false).chainID ?? 4;

    String? signValue;
    if (_wallet!.chainType == MCoinType.MCoinType_ETH.index) {
      signValue = await _wallet!.sign(
        to: params.to,
        pin: pin!,
        value: params.amount!,
        ethSignParams: params.transParams as ETHSignParams,
      );
    }
    LogUtil.v("签名数据 $signValue");
    HWToast.showLoading(
      clickClose: true,
    );
    if (signValue?.isValid() == true) {
      ChainServices.pushData(_wallet!.chainType!, signValue, (result, code) {
        HWToast.hiddenAllToast();
        if (code == 200) {
          HWToast.showText(text: "payment_transsuccess".local());
          TransRecordModel model = TransRecordModel();
          model.txid = result;
          model.amount = params.amount!;
          model.fromAdd = params.from;
          model.date = DateUtil.getNowDateStr();
          model.symbol = token;
          model.coinType = "ETH";
          model.fee = params.fee;
          model.toAdd = params.to;
          model.transStatus = MTransState.MTransState_Pending.index;
          model.transType = MTransListType.MTransListType_Out.index;
          model.chainid = chainID;
          TransRecordModel.insertTrxList(model);
          Future.delayed(Duration(seconds: 3))
              .then((value) => {Routers.goBackWithParams(context, {})});
        } else {
          HWToast.showText(text: "payment_transfailere".local() + result);
        }
      });
    } else {
      HWToast.showText(text: "payment_transfailere".local());
    }
  }

  Widget _getFeeWidget() {
    MCollectionTokens? tokens = Provider.of<CurrentChooseWalletState>(
      context,
    ).chooseTokens;
    String amountType =
        Provider.of<CurrentChooseWalletState>(context, listen: false)
            .currencySymbolStr;
    String? coinType = tokens?.coinType;
    coinType ??= "";
    Widget _getAction() {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _updateFeeWidget(),
        child: Container(
          child: Text(
            _isCustomFee == false
                ? "payment_customfee".local()
                : "payment_defaultfee".local(),
            textAlign: TextAlign.right,
            style: TextStyle(
              color: ColorUtils.rgba(78, 108, 220, 1),
              fontWeight: FontWeight.w400,
              fontSize: OffsetWidget.setSp(10),
            ),
          ),
        ),
      );
    }

    Widget _getFeeWidget() {
      return _isCustomFee == true
          ? CustomTextField(
              controller: _customFeeEC,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChange: (v) => {_customfeeChange(v)},
              style: TextStyle(
                color: ColorUtils.rgba(153, 153, 153, 1),
                fontSize: OffsetWidget.setSp(12),
                fontWeight: FontWeight.w400,
              ),
              decoration: CustomTextField.getUnderLineDecoration(),
            )
          : Row(
              children: [
                Text(
                  "payment_slow".local(),
                  style: TextStyle(
                      color: ColorUtils.rgba(222, 224, 223, 1),
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(12)),
                ),
                OffsetWidget.hGap(6),
                Expanded(
                  child: SliderTheme(
                    //自定义风格
                    data: SliderTheme.of(context).copyWith(
                        activeTrackColor: ColorUtils.rgba(51, 230, 246, 1),
                        inactiveTrackColor: ColorUtils.rgba(38, 35, 57, 1),
                        thumbColor: ColorUtils.rgba(51, 230, 246, 1),
                        overlayColor: ColorUtils.rgba(51, 230, 246, 1),
                        overlayShape: RoundSliderOverlayShape(
                          overlayRadius: 12,
                        ),
                        thumbShape: RoundSliderThumbShape(
                          disabledThumbRadius: 12,
                          enabledThumbRadius: 12,
                        ),
                        trackHeight: 6),
                    child: Slider(
                        value: _feeOffset.toDouble(),
                        onChanged: (v) {
                          _sliderChange(v);
                        },
                        max: sliderMax,
                        min: sliderMin),
                  ),
                ),
                OffsetWidget.hGap(6),
                Text(
                  "payment_high".local(),
                  style: TextStyle(
                      color: ColorUtils.rgba(222, 224, 223, 1),
                      fontWeight: FontWightHelper.semiBold,
                      fontSize: OffsetWidget.setSp(12)),
                ),
              ],
            );
    }

    return Container(
      padding: EdgeInsets.only(top: OffsetWidget.setSc(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(18, 0, 18, 0),
            alignment: Alignment.center,
            height: OffsetWidget.setSc(48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Color(Constant.textfield_border_color),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: OffsetWidget.setSc(200),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "payment_fee".local() + ": $_feeValue",
                        style: TextStyle(
                          color: ColorUtils.rgba(222, 224, 223, 1),
                          fontWeight: FontWightHelper.semiBold,
                          fontSize: OffsetWidget.setSp(12),
                        ),
                      ),
                      OffsetWidget.hGap(3),
                      Expanded(
                        child: Text(
                          "≈$amountType" +
                              (_feeValue! * tokenPrice!).toStringAsFixed(2),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: ColorUtils.rgba(153, 153, 153, 1),
                            fontWeight: FontWightHelper.semiBold,
                            fontSize: OffsetWidget.setSp(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // _getAction(),
              ],
            ),
          ),
          /*   CustomTextField(
                padding: EdgeInsets.only(top: OffsetWidget.setSc(26)),
                controller: _valueEC,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  CustomTextField.decimalInputFormatter(decimals),
                ],
                style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12),
                  fontWeight: FontWightHelper.regular,
                ),
                onChange: (value) {
                  allTrans = false;
                },
                decoration: CustomTextField.getBorderLineDecoration(
                  hintText: "payment_value".local(),
                  contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
                  hintStyle: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(12)),
                  counterText: "payment_balance".local() + ":$_balanceNum",
                  counterStyle: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(12)),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _tapTransAllAmount,
                    child: Container(
                      width: OffsetWidget.setSc(50),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        "wallets_all".local(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ColorUtils.rgba(78, 108, 220, 1),
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(12)),
                      ),
                    ),
                  ),
                ),
              ),*/
          OffsetWidget.vGap(15),
          _getFeeWidget(),
          OffsetWidget.vGap(8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$_feeValue $coinType",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWightHelper.regular,
                  fontSize: OffsetWidget.setSp(12),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MCollectionTokens? tokens = Provider.of<CurrentChooseWalletState>(
      context,
    ).chooseTokens;
    int? decimals = tokens?.decimals;
    String? token = tokens?.token;
    token ??= "";
    return CustomPageView(
      title: CustomPageView.getDefaultTitle(
        titleStr: "wallet_payment".local(),
      ),
      actions: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => {
            _startScanAddress(),
          },
          child: Container(
            padding: EdgeInsets.only(right: 15),
            height: 45,
            width: 45,
            alignment: Alignment.centerRight,
            child: LoadAssetsImage(
              Constant.ASSETS_IMG + "icon/icon_scan.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
      ],
      child: Container(
          padding: EdgeInsets.only(
              left: OffsetWidget.setSc(20),
              top: OffsetWidget.setSc(15),
              right: OffsetWidget.setSc(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: !hiddenTokens,
                child: GestureDetector(
                  onTap: tapSelectToken,
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: OffsetWidget.setSc(24),
                    ),
                    padding: EdgeInsets.only(
                        left: OffsetWidget.setSc(18),
                        right: OffsetWidget.setSc(18)),
                    alignment: Alignment.center,
                    height: OffsetWidget.setSc(45),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorUtils.rgba(73, 73, 73, 0.29),
                      border: Border.all(
                        color: ColorUtils.rgba(50, 55, 85, 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          token,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(14),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              "wallet_Selecttoken".local(),
                              style: TextStyle(
                                color: ColorUtils.rgba(153, 153, 153, 1),
                                fontWeight: FontWightHelper.regular,
                                fontSize: OffsetWidget.setSp(12),
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: OffsetWidget.setSc(10)),
                              child: LoadAssetsImage(
                                Constant.ASSETS_IMG +
                                    "icon/arrow_white_right.png",
                                width: 6,
                                height: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CustomTextField(
                  controller: _addressEC,
                  style: TextStyle(
                    color: ColorUtils.rgba(153, 153, 153, 1),
                    fontSize: OffsetWidget.setSp(12),
                    fontWeight: FontWightHelper.regular,
                  ),
                  decoration: CustomTextField.getBorderLineDecoration(
                    suffixIcon: GestureDetector(
                      child: Container(
                        width: 45,
                        child: LoadAssetsImage(
                          Constant.ASSETS_IMG + "icon/icon_user.png",
                          height: 24,
                          width: 24,
                        ),
                      ),
                      onTap: () {
                        Map<String, dynamic> params = {"state": "payment"};
                        Routers.push(context, Routers.mineContactPage,
                                params: params)
                            .then((value) => {
                                  LogUtil.v(value),
                                  _addressEC.text =
                                      ContactAddress.fromJson(value).address
                                });
                      },
                    ),
                    contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
                    hintText: "payment_address".local(),
                    hintStyle: TextStyle(
                        color: Color(0XFF585858),
                        fontWeight: FontWightHelper.regular,
                        fontSize: OffsetWidget.setSp(12)),
                  )),
              CustomTextField(
                padding: EdgeInsets.only(top: OffsetWidget.setSc(26)),
                controller: _valueEC,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  CustomTextField.decimalInputFormatter(decimals),
                ],
                style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12),
                  fontWeight: FontWightHelper.regular,
                ),
                onChange: (value) {
                  allTrans = false;
                },
                decoration: CustomTextField.getBorderLineDecoration(
                  hintText: "payment_value".local(),
                  contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
                  hintStyle: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(12)),
                  counterText: "payment_balance".local() + ":$_balanceNum",
                  counterStyle: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(12)),
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _tapTransAllAmount,
                    child: Container(
                      width: OffsetWidget.setSc(50),
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 15),
                      child: Text(
                        "wallets_all".local(),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: ColorUtils.rgba(78, 108, 220, 1),
                            fontWeight: FontWightHelper.regular,
                            fontSize: OffsetWidget.setSp(12)),
                      ),
                    ),
                  ),
                ),
              ),
              CustomTextField(
                controller: _remarkEC,
                padding: EdgeInsets.only(top: OffsetWidget.setSc(25)),
                onChange: (value) => {
                  _remarkStringChange(value),
                },
                style: TextStyle(
                  color: ColorUtils.rgba(153, 153, 153, 1),
                  fontSize: OffsetWidget.setSp(12),
                  fontWeight: FontWightHelper.regular,
                ),
                decoration: CustomTextField.getBorderLineDecoration(
                  hintText: "wallet_transdesc".local(),
                  contentPadding: EdgeInsets.fromLTRB(18, 15, 18, 15),
                  hintStyle: TextStyle(
                      color: ColorUtils.rgba(153, 153, 153, 1),
                      fontWeight: FontWightHelper.regular,
                      fontSize: OffsetWidget.setSp(12)),
                ),
              ),
              _getFeeWidget(),
              GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _popupInfo,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: OffsetWidget.setSc(84),
                        left: OffsetWidget.setSc(16),
                        right: OffsetWidget.setSc(16)),
                    height: OffsetWidget.setSc(46),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(OffsetWidget.setSc(8)),
                        color: ColorUtils.rgba(78, 108, 220, 1)),
                    child: Text(
                      "comfirm_trans_payment".local(),
                      style: TextStyle(
                          fontWeight: FontWightHelper.semiBold,
                          fontSize: OffsetWidget.setSp(20),
                          color: Colors.white),
                    ),
                  )),
            ],
          )),
    );
  }
}
