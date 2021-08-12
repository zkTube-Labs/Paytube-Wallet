#include <jni.h>
#include <string>
#include "com_fictitious_money_purse_utils_XMHCoinUtitls.h"
#include "test.h"
#include "CoinIDLIBInterface.h"
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <unistd.h>

static const char *pkgName1 = "com.fictitious.money.purse";
static const char *pkgName2 = "com.mwt.wallet.alltoken";
const char *app_signature_sha1= "916766467347C5C639821185B0D62A25629FCF2A";
const static u8 app_prv[32] = {0xcf,0x1a,0x68,0xba,0x5c,0x0c,0x47,0x76,0x54,0x36,0x6f,0x54,0xce,0x62,0x41,0x5b,0xe5,0xa4,0xdd,0xd8,0x66,0x82,0x13,0x0c,0x64,0xa2,0xee,0x7b,0x65,0xb3,0xf7,0x4f };
const static u8 coinid_pub[33] = {0x03,0x88,0x5d,0x04,0x00,0x5c,0x2e,0xb5,0x8a,0xd3,0x25,0x10,0x1a,0x53,0x93,0x9f,0x64,0x5d,0xd0,0xdd,0xbf,0xbe,0x1e,0x26,0x70,0x74,0x78,0x52,0x6b,0x19,0x0a,0x14,0xa2 };
const char HexCode[]={'0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'};
static jboolean g_isAuth = false;
extern "C"
JNIEXPORT jstring JNICALL
Java_com_fictitious_money_purse_utils_MainActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string hello = "Hello from C++";
    return env->NewStringUTF(hello.c_str());
}

static u8* ConvertJByteaArrayToChars(JNIEnv *env, jbyteArray bytearray)
{
    u8 *chars = NULL;
    jbyte *bytes;
    bytes = env->GetByteArrayElements(bytearray, 0);
    int chars_len = env->GetArrayLength(bytearray);
    chars = new u8[chars_len];
    memcpy(chars, bytes, chars_len);

    env->ReleaseByteArrayElements(bytearray, bytes, 0);

    return chars;
}

static u16* ConvertJShortArrayToShort(JNIEnv *env, jshortArray shortarray)
{
    u16 *chars = NULL;
    jshort *shorts;
    shorts = env->GetShortArrayElements(shortarray, 0);
    int shorts_len = env->GetArrayLength(shortarray);
    chars = new u16[shorts_len];
    memcpy((u8*)chars,(u8*)shorts, shorts_len*2);

    env->ReleaseShortArrayElements(shortarray, shorts, 0);

    return chars;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1generateMnemonicIndex
        (JNIEnv *env, jclass, jbyteArray entropyBuffer, jbyte byteCounter, jbyteArray mnemonicIndexBuffer)
{
    bool    result;
    jbyte   indexLen;
    u8      *indexBuffer;
    u8      *entBuffer;

    if(!g_isAuth) return false;
    indexBuffer = ConvertJByteaArrayToChars(env,  mnemonicIndexBuffer);
    entBuffer = ConvertJByteaArrayToChars(env,  entropyBuffer);
    indexLen = env->GetArrayLength(mnemonicIndexBuffer);

    result =  CoinID_generateMnemonicIndex(entBuffer, byteCounter, indexBuffer);
    env->SetByteArrayRegion(mnemonicIndexBuffer, 0, indexLen,(jbyte*)indexBuffer);
    return result;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1SetMaster
        (JNIEnv *env, jclass, jbyteArray mnemonicBuffer, jshort mnemonicLen)
{
    u8      *memBuffer;

    if(!g_isAuth) return false;
    memBuffer = ConvertJByteaArrayToChars(env,  mnemonicBuffer);
    return CoinID_SetMaster(memBuffer, mnemonicLen);
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveEOSKeyRoot
        (JNIEnv *, jclass)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveEOSKeyRoot();
}

JNIEXPORT jbyte JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveEOSKeyAccount
  (JNIEnv *, jclass, jint index)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveEOSKeyAccount(index);
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveEOSKey
        (JNIEnv *env, jclass, jint index)
{
    jbyteArray jbarr;
    u8 *outKey;

    if(!g_isAuth) return NULL;
    jbarr = env->NewByteArray(97);

    outKey =  CoinID_DeriveEOSKey(index);
    if(!outKey) return NULL;
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)outKey);

    return jbarr;
}

JNIEXPORT jint JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ECDSA_1sign
        (JNIEnv *env, jclass, jbyteArray msg, jint length, jbyteArray key, jbyteArray sigData)
{
    jbyteArray jbSigData;
    u8      *msgBuffer;
    u8      *keyBuffer;
    u8      *sigDataBuffer;
    jint   result;
    if(!g_isAuth) return false;
    msgBuffer = ConvertJByteaArrayToChars(env,  msg);
    sigDataBuffer = ConvertJByteaArrayToChars(env,  sigData);
    if(key == nullptr)
    {
        result = CoinID_ECDSA_sign(msgBuffer, length, (u8 *)app_prv, sigDataBuffer);
    } else{
        keyBuffer = ConvertJByteaArrayToChars(env,  key);
        result = CoinID_ECDSA_sign(msgBuffer, length, keyBuffer, sigDataBuffer);
    }
    env->SetByteArrayRegion(sigData, 0, 64, (jbyte*)sigDataBuffer);
   return result;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportEOSPubKey
        (JNIEnv *env, jclass, jbyteArray pubKey)
{
    jbyteArray jbSigData;
    u8      *keyBuffer;
    int     i = 0;
    if(!g_isAuth) return NULL;
    keyBuffer = ConvertJByteaArrayToChars(env,  pubKey);
    u8 *tempkey = CoinID_ExportEOSPubKey(keyBuffer);
    while(tempkey[i] != '\0') i++;

    jbSigData = env->NewByteArray(i);
    env->SetByteArrayRegion(jbSigData, 0, i, (jbyte*)tempkey);

    return jbSigData;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportEOSPrvKey
        (JNIEnv *env, jclass, jbyteArray prvKey)
{
    jbyteArray jbSigData;
    u8      *keyBuffer;
    int     i = 0;

    if(!g_isAuth) return NULL;
    keyBuffer = ConvertJByteaArrayToChars(env,  prvKey);
    u8 *tempkey = CoinID_ExportEOSPrvKey(keyBuffer);
    while(tempkey[i] != '\0') i++;

    jbSigData = env->NewByteArray(i);
    env->SetByteArrayRegion(jbSigData, 0, i, (jbyte*)tempkey);

    return jbSigData;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportEOSPrvKeyCheck
        (JNIEnv *env, jclass, jbyteArray prvKey, jbyte length)
{
    u8      *keyBuffer;

    if(!g_isAuth) return false;
    keyBuffer = ConvertJByteaArrayToChars(env,  prvKey);
    return CoinID_ImportEOSPrvKeyCheck(keyBuffer, length);

}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportEOSPrvKey
        (JNIEnv *env, jclass, jbyteArray prvKey, jbyte length)
{
    u8      *keyBuffer;
    u8      *outkeyBuffer;
    jbyteArray jbSigData;
    int     i = 0;

    if(!g_isAuth) return NULL;
    keyBuffer = ConvertJByteaArrayToChars(env,  prvKey);
    outkeyBuffer =  CoinID_ImportEOSPrvKey(keyBuffer, length);
    if(!outkeyBuffer) return NULL;
    jbSigData = env->NewByteArray(97);
    env->SetByteArrayRegion(jbSigData, 0, 97, (jbyte*)outkeyBuffer);

    return jbSigData;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1GetTranSigJson
        (JNIEnv *env , jclass, jbyteArray jsonTran, jshort length, jbyteArray prvKey)
{
    u8      *jsonBuffer;
    u8      *keyBuffer;
    jbyteArray jbSigData;
    u8      *outJsonBuf;
    int     i = 0;

    if(!g_isAuth) return NULL;
    jsonBuffer = ConvertJByteaArrayToChars(env,  jsonTran);
    keyBuffer = ConvertJByteaArrayToChars(env,  prvKey);
    outJsonBuf = CoinID_GetTranSigJson(jsonBuffer, length, keyBuffer);
    while(outJsonBuf[i] != '\0') i++;
    jbSigData = env->NewByteArray(i);
    env->SetByteArrayRegion(jbSigData, 0, i, (jbyte*)outJsonBuf);

    return jbSigData;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1EncKeyByAES128CBC
        (JNIEnv *env, jclass, jbyteArray input, jshort inputLen, jbyteArray inputPIN, jbyte pinLen, jbyteArray output, jbyteArray uuid, jbyte len)
{
    u8 *inputBuf;
    u8 * pinBuf;
    u8 *outputBuf;
    u8 *uuidBuf;
    jboolean result;
    int chars_len;

    if(!g_isAuth) return false;
    inputBuf = ConvertJByteaArrayToChars(env,  input);
    pinBuf = ConvertJByteaArrayToChars(env,  inputPIN);
    outputBuf = ConvertJByteaArrayToChars(env,  output);
    uuidBuf = ConvertJByteaArrayToChars(env,  uuid);
    result = CoinID_EncKeyByAES128CBC(inputBuf,inputLen,pinBuf,pinLen,outputBuf, uuidBuf, len);
    chars_len = env->GetArrayLength(output);
    env->SetByteArrayRegion(output, 0, chars_len, (jbyte*)outputBuf);
    return result;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DecKeyByAES128CBC
        (JNIEnv *env, jclass, jbyteArray input, jshort inputLen, jbyteArray inputPIN, jbyte pinLen, jbyteArray output, jbyteArray uuid, jbyte len)
{
    u8 *inputBuf;
    u8 * pinBuf;
    u8 *outputBuf;
    u8 *uuidBuf;
    jboolean result;
    int chars_len;

    if(!g_isAuth) return false;
    inputBuf = ConvertJByteaArrayToChars(env,  input);
    pinBuf = ConvertJByteaArrayToChars(env,  inputPIN);
    outputBuf = ConvertJByteaArrayToChars(env,  output);
    uuidBuf = ConvertJByteaArrayToChars(env,  uuid);
    result = CoinID_DecKeyByAES128CBC(inputBuf,inputLen,pinBuf,pinLen,outputBuf, uuidBuf, len);
    chars_len = env->GetArrayLength(output);
    env->SetByteArrayRegion(output, 0, chars_len, (jbyte*)outputBuf);
    return result;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveETHKeyRoot
        (JNIEnv *env, jclass)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveETHKeyRoot();
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveETHKey
        (JNIEnv *env, jclass, jint index)
{
    jbyteArray jbarr;
    u8 *outKey;

    if(!g_isAuth) return NULL;
    jbarr = env->NewByteArray(97);
    outKey =  CoinID_DeriveETHKey(index);
    if(!outKey) return NULL;
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)outKey);

    return jbarr;
}

JNIEXPORT jbyte JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveETHKeyAccount
  (JNIEnv *, jclass, jint index)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveETHKeyAccount(index);
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportETHPubKey
        (JNIEnv *env, jclass, jbyteArray pubKey)
{
    jbyteArray jbarr;
    u8 *outKey;
    u8 * pubKeyBuf;

    if(!g_isAuth) return NULL;
    jbarr = env->NewByteArray(40);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    outKey = CoinID_ExportETHPubKey(pubKeyBuf);
    env->SetByteArrayRegion(jbarr, 0, 40, (jbyte*)outKey);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtEthTransaction
        (JNIEnv *env, jclass, jbyteArray p_nonce, jshort nonce_len, jbyteArray p_gasprice, jshort gasprice_len, jbyteArray p_startgas, jshort startgas_len, jbyteArray to, jbyteArray p_value, jshort value_len, jbyteArray p_data, jshort data_len, jbyteArray p_chainId, jshort chainId_len, jbyteArray prvKey)
{
    jbyteArray jbarr;
    u8 *nonce;
    u8 *gasprice;
    u8 *startgas;
    u8 *toBuf;
    u8 *value;
    u8 *data;
    u8 *chainId;
    u8 *prvKeyBuf;
    u8 *sigData;
    int i=0;
    if(!g_isAuth) return NULL;
    nonce = ConvertJByteaArrayToChars(env,  p_nonce);
    gasprice = ConvertJByteaArrayToChars(env,  p_gasprice);
    startgas = ConvertJByteaArrayToChars(env,  p_startgas);
    toBuf = ConvertJByteaArrayToChars(env,  to);
    value = ConvertJByteaArrayToChars(env,  p_value);
    data = ConvertJByteaArrayToChars(env,  p_data);
    chainId = ConvertJByteaArrayToChars(env,  p_chainId);
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    nonce_len = strlen((char*)nonce);
    gasprice_len = strlen((char*)gasprice);
    startgas_len = strlen((char*)startgas);
    value_len = strlen((char*)value);
    //data_len = strlen((char*)data);
    chainId_len = strlen((char*)chainId);
    sigData = CoinID_sigtEthTransaction(nonce,  nonce_len, gasprice,  gasprice_len, startgas,  startgas_len, toBuf, value,  value_len, data, data_len, chainId, chainId_len, prvKeyBuf);
    while(sigData[i] != '\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)sigData);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getMasterPubKey
        (JNIEnv *env, jclass)
{
    u8 *pubKey;
    int i=0;
    jbyteArray jbarr;
    if(!g_isAuth) return NULL;
    pubKey = CoinID_getMasterPubKey();
    while(pubKey[i] != '\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)pubKey);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeTranJSON
  (JNIEnv *env, jclass, jbyteArray jsonTran, jshort length, jbyteArray hash, jbyteArray msgLength)
{
    u8 *jsonTranBuf;
    u8 *packDataBuf;
    u8 *hashBuf;
    u8 *msgLengthBuf;
    short packLength;
    jbyteArray jbarr;

    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    hashBuf = ConvertJByteaArrayToChars(env,  hash);
    msgLengthBuf = ConvertJByteaArrayToChars(env,  msgLength);

    packDataBuf = CoinID_serializeTranJSON(jsonTranBuf, length, hashBuf, msgLengthBuf);
    env->SetByteArrayRegion(hash, 0, 32, (jbyte*)hashBuf);
    packLength = (msgLengthBuf[0]<<8)|(msgLengthBuf[1]);
    env->SetByteArrayRegion(msgLength, 0, 2, (jbyte*)msgLengthBuf);
    jbarr = env->NewByteArray(packLength);
    env->SetByteArrayRegion(jbarr, 0, packLength, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packTranJson
  (JNIEnv *env, jclass, jbyteArray sigData, jbyteArray packData, jint recid, jshort msgLen)
{
    u8 *sigDataBuf;
    u8 *packDataBuf;
    u8 *tranDataBuf;
    jbyteArray jbarr;
    int i=0;

    if(!g_isAuth) return NULL;
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    packDataBuf = ConvertJByteaArrayToChars(env,  packData);

    tranDataBuf =  CoinID_packTranJson(sigDataBuf, packDataBuf, recid, msgLen);

    while(tranDataBuf[i] != '\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)tranDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genBTCAddress
        (JNIEnv *env, jclass, jbyte prefix, jbyteArray pubKey, jbyte length, jbyte type)
{
    u8 *pubKeyBuf;
    u8 *packDataBuf;
    jbyteArray jbarr;
    int i=0;

    if(!g_isAuth) return NULL;
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    packDataBuf =  CoinID_genBTCAddress(prefix, pubKeyBuf, length, type);

    while(packDataBuf[i] != '\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtBTCTransaction
        (JNIEnv *env, jclass , jbyteArray jsonTran, jshort length, jbyteArray prvKey)
{
    u8 *jsonTranBuf;
    u8 *prvKeyBuf;
    u8 *packDataBuf;
    u16 tempLength = 0;
    jbyteArray jbarr;

    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);

    packDataBuf = CoinID_sigtBTCTransaction(jsonTranBuf, length, prvKeyBuf);
    while(packDataBuf[tempLength] != '\0') tempLength++;

    jbarr = env->NewByteArray(tempLength);
    env->SetByteArrayRegion(jbarr, 0, tempLength, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportETHPrvKey
        (JNIEnv *env, jclass, jbyteArray prvKey)
{
    u8 *prvKeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);

    packDataBuf =  CoinID_ImportETHPrvKey(prvKeyBuf);
    if(!packDataBuf) return NULL;
    jbarr = env->NewByteArray(97);
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveBTCKeyRoot
        (JNIEnv *, jclass)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveBTCKeyRoot();
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveBTCKeyAccount
        (JNIEnv *, jclass, jint index)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveBTCKeyAccount(index);
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveBTCKey
        (JNIEnv *env, jclass, jint index)
{
    jbyteArray jbarr;
    u8 *outKey;
    if(!g_isAuth) return NULL;
    jbarr = env->NewByteArray(97);
    outKey =  CoinID_DeriveBTCKey(index);
    if(!outKey) return NULL;
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)outKey);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportBTCPrvKeyByWIF
        (JNIEnv *env, jclass, jbyteArray prvKey, jshort length)
{
    u8 *prvKeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);

    packDataBuf =  CoinID_ImportBTCPrvKeyByWIF(prvKeyBuf,length);
    if(!packDataBuf) return NULL;
    jbarr = env->NewByteArray(97);
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportBTCPrvKeyByWIF
        (JNIEnv *env, jclass, jbyteArray prvKey)
{
    u8 *prvKeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    int i=0;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);

    packDataBuf =  CoinID_ExportBTCPrvKeyByWIF(prvKeyBuf);
    while(packDataBuf[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genScriptHash
        (JNIEnv *env, jclass, jbyteArray address, jshort length)
{
    u8 *addressBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    int i=0;
    if(!g_isAuth) return NULL;
    addressBuf = ConvertJByteaArrayToChars(env,  address);

    packDataBuf =  CoinID_genScriptHash(addressBuf, length);
    while(packDataBuf[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeETHTranJSON
    (JNIEnv *env, jclass, jbyteArray p_nonce, jshort nonce_len, jbyteArray p_gasprice, jshort gasprice_len, jbyteArray p_startgas, jshort startgas_len, jbyteArray to, jbyteArray p_value, jshort value_len, jbyteArray p_data, jshort data_len, jbyteArray p_chainId, jshort chainId_len, jbyteArray sigHash, jbyteArray outLength)
{
    jbyteArray jbarr;
    u8 *nonce;
    u8 *gasprice;
    u8 *startgas;
    u8 *toBuf;
    u8 *value;
    u8 *data;
    u8 *chainId;
    u8 *sigHashBuf;
    u8 *sigData;
    u8 *outLengthBuf;
    short length;
    int i=0;
    if(!g_isAuth) return NULL;
    nonce = ConvertJByteaArrayToChars(env,  p_nonce);
    gasprice = ConvertJByteaArrayToChars(env,  p_gasprice);
    startgas = ConvertJByteaArrayToChars(env,  p_startgas);
    toBuf = ConvertJByteaArrayToChars(env,  to);
    value = ConvertJByteaArrayToChars(env,  p_value);
    data = ConvertJByteaArrayToChars(env,  p_data);
    chainId = ConvertJByteaArrayToChars(env,  p_chainId);
    sigHashBuf = ConvertJByteaArrayToChars(env,  sigHash);
    outLengthBuf = ConvertJByteaArrayToChars(env,  outLength);
    nonce_len = strlen((char*)nonce);
    gasprice_len = strlen((char*)gasprice);
    startgas_len = strlen((char*)startgas);
    value_len = strlen((char*)value);
    //data_len = strlen((char*)data);
    chainId_len = strlen((char*)chainId);
    sigData = CoinID_serializeETHTranJSON(nonce,  nonce_len, gasprice,  gasprice_len, startgas,  startgas_len, toBuf, value,  value_len, data, data_len, chainId, chainId_len, sigHashBuf, outLengthBuf);
    env->SetByteArrayRegion(sigHash, 0, 32, (jbyte*)sigHashBuf);
    length = (outLengthBuf[0]<<8)|(outLengthBuf[1]);
    env->SetByteArrayRegion(outLength, 0, 2, (jbyte*)outLengthBuf);
    jbarr = env->NewByteArray(length);
    env->SetByteArrayRegion(jbarr, 0, length, (jbyte*)sigData);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packETHTranJson
        (JNIEnv *env, jclass, jbyteArray sigOut, jbyteArray sigData, jint recid, jbyteArray p_chainId, jshort chainId_len, jbyteArray serLen)
{
    jbyteArray jbarr;
    u8 *sigOutBuf;
    u8 *sigDataBuf;
    u8 *p_chainIdBuf;
    u8 *serLenBuf;
    u8 *packData;
    u16 i=0;
    if(!g_isAuth) return NULL;
    sigOutBuf = ConvertJByteaArrayToChars(env,  sigOut);
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    p_chainIdBuf = ConvertJByteaArrayToChars(env,  p_chainId);
    serLenBuf = ConvertJByteaArrayToChars(env,  serLen);
    chainId_len = strlen((char*)p_chainIdBuf);
    packData = CoinID_packETHTranJson(sigOutBuf,sigDataBuf,recid, p_chainIdBuf, chainId_len,serLenBuf);
    env->SetByteArrayRegion(serLen, 0, 2, (jbyte*)serLenBuf);
    while(packData[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packData);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBTCTranJSON
        (JNIEnv *env, jclass, jbyteArray jsonTran, jshort length, jbyteArray pubKey, jbyteArray outLen)
{
    jbyteArray jbarr;
    u8 *jsonTranBuf;
    u8 *pubKeyBuf;
    u8 *outLenBuf;
    u8 *packDataBuf;
    u16 i=0;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    outLenBuf = ConvertJByteaArrayToChars(env,  outLen);
    packDataBuf = CoinID_serializeBTCTranJSON(jsonTranBuf,  length, pubKeyBuf,outLenBuf);
    env->SetByteArrayRegion(outLen, 0, 2, (jbyte*)outLenBuf);
    len = (outLenBuf[0]<<8)|(outLenBuf[1]);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0, len, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTCTranJson
        (JNIEnv *env, jclass, jbyte isSegwit, jbyteArray sigData, jint length, jbyteArray pubKey)
{
    jbyteArray jbarr;
    u8 *sigDataBuf;
    u8 *pubKeyBuf;
    u8 *packDataBuf;
    u16 i=0;
    if(!g_isAuth) return NULL;
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    packDataBuf = CoinID_packBTCTranJson(isSegwit, sigDataBuf, length, pubKeyBuf);
    while(packDataBuf[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkMemoValid
        (JNIEnv *env, jclass, jshortArray memoIndex, jbyte count)
{
    u16 *memoIndexBuf;
    if(!g_isAuth) return false;
    memoIndexBuf = ConvertJShortArrayToShort(env,  memoIndex);

    return CoinID_checkMemoValid(memoIndexBuf, count);
}

JNIEXPORT void JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genTrueRandom
        (JNIEnv *env, jclass, jbyteArray random)
{
    u8 *randomBuf;
    static int dev_random_fd = -1;
    int bytes_to_read;
    unsigned random_value;
    int bytes_read;
    int total_byte;
    u8 *prtRandomBuf;
    if(!g_isAuth) return ;
    randomBuf       = ConvertJByteaArrayToChars(env,  random);
    prtRandomBuf    = randomBuf;
    bytes_to_read   = env->GetArrayLength(random);
    total_byte      = bytes_to_read;
    if (dev_random_fd == -1)
    {
        dev_random_fd = open("/dev/random", O_RDONLY);
    }

    do
    {
        bytes_read = read(dev_random_fd, prtRandomBuf, bytes_to_read);
        bytes_to_read -= bytes_read;
        prtRandomBuf += bytes_read;
    }while(bytes_to_read > 0);
    env->SetByteArrayRegion(random, 0, total_byte, (jbyte*)randomBuf);
    return ;
}

static jboolean  checkPkgName(JNIEnv *env, jobject contextObject)
{
    jclass context_class;
    jmethodID methodId;
    jobject package_manager;
    jstring package_name;

    if(contextObject ==NULL)
    {
        return false;
    }
    context_class = env->GetObjectClass(contextObject);

     methodId = env->GetMethodID(context_class, "getPackageManager", "()Landroid/content/pm/PackageManager;");
     package_manager = env->CallObjectMethod(contextObject, methodId);
    if (package_manager == NULL) {
        return false;
    }
    methodId = env->GetMethodID(context_class, "getPackageName", "()Ljava/lang/String;");
    package_name = (jstring)env->CallObjectMethod(contextObject, methodId);
    if (package_name == NULL) {
        return false;
    }
    env->DeleteLocalRef(context_class);

    const char* jcstr = env->GetStringUTFChars(package_name,JNI_FALSE);

    return (memcmp(jcstr, pkgName1, (sizeof(pkgName1) - 1)) == 0)||(memcmp(jcstr, pkgName2, (sizeof(pkgName2) - 1)) == 0);
}
static jboolean checkPkgSigHash(JNIEnv *env, jobject context_object)
{
    jclass context_class = env->GetObjectClass(context_object);

    //context.getPackageManager()
    jmethodID methodId = env->GetMethodID(context_class, "getPackageManager", "()Landroid/content/pm/PackageManager;");
    jobject package_manager_object = env->CallObjectMethod(context_object, methodId);
    if (package_manager_object == NULL) {
        return false;
    }

    //context.getPackageName()
    methodId = env->GetMethodID(context_class, "getPackageName", "()Ljava/lang/String;");
    jstring package_name_string = (jstring)env->CallObjectMethod(context_object, methodId);
    if (package_name_string == NULL) {
        return false;
    }
    env->DeleteLocalRef(context_class);

    //PackageManager.getPackageInfo(Sting, int)
    //public static final int GET_SIGNATURES= 0x00000040;
    jclass pack_manager_class = env->GetObjectClass(package_manager_object);
    methodId = env->GetMethodID(pack_manager_class, "getPackageInfo", "(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;");
    env->DeleteLocalRef(pack_manager_class);
    jobject package_info_object = env->CallObjectMethod(package_manager_object, methodId, package_name_string, 0x40);
    if (package_info_object == NULL) {
        return false;
    }
    env->DeleteLocalRef(package_manager_object);

    //PackageInfo.signatures[0]
    jclass package_info_class = env->GetObjectClass(package_info_object);
    jfieldID fieldId = env->GetFieldID(package_info_class, "signatures", "[Landroid/content/pm/Signature;");
    env->DeleteLocalRef(package_info_class);
    jobjectArray signature_object_array = (jobjectArray)env->GetObjectField(package_info_object, fieldId);
    if (signature_object_array == NULL) {
        return false;
    }
    jobject signature_object = env->GetObjectArrayElement(signature_object_array, 0);
    env->DeleteLocalRef(package_info_object);

    //Signature.toByteArray()
    jclass signature_class = env->GetObjectClass(signature_object);
    methodId = env->GetMethodID(signature_class, "toByteArray", "()[B");
    env->DeleteLocalRef(signature_class);
    jbyteArray signature_byte = (jbyteArray) env->CallObjectMethod(signature_object, methodId);

    //new ByteArrayInputStream
    jclass byte_array_input_class=env->FindClass("java/io/ByteArrayInputStream");
    methodId=env->GetMethodID(byte_array_input_class,"<init>","([B)V");
    jobject byte_array_input=env->NewObject(byte_array_input_class,methodId,signature_byte);

    //CertificateFactory.getInstance("X.509")
    jclass certificate_factory_class=env->FindClass("java/security/cert/CertificateFactory");
    methodId=env->GetStaticMethodID(certificate_factory_class,"getInstance","(Ljava/lang/String;)Ljava/security/cert/CertificateFactory;");
    jstring x_509_jstring=env->NewStringUTF("X.509");
    jobject cert_factory=env->CallStaticObjectMethod(certificate_factory_class,methodId,x_509_jstring);

    //certFactory.generateCertificate(byteIn);
    methodId=env->GetMethodID(certificate_factory_class,"generateCertificate",("(Ljava/io/InputStream;)Ljava/security/cert/Certificate;"));
    jobject x509_cert=env->CallObjectMethod(cert_factory,methodId,byte_array_input);
    env->DeleteLocalRef(certificate_factory_class);

    //cert.getEncoded()
    jclass x509_cert_class=env->GetObjectClass(x509_cert);
    methodId=env->GetMethodID(x509_cert_class,"getEncoded","()[B");
    jbyteArray cert_byte=(jbyteArray)env->CallObjectMethod(x509_cert,methodId);
    env->DeleteLocalRef(x509_cert_class);

    //MessageDigest.getInstance("SHA1")
    jclass message_digest_class=env->FindClass("java/security/MessageDigest");
    methodId=env->GetStaticMethodID(message_digest_class,"getInstance","(Ljava/lang/String;)Ljava/security/MessageDigest;");
    jstring sha1_jstring=env->NewStringUTF("SHA1");
    jobject sha1_digest=env->CallStaticObjectMethod(message_digest_class,methodId,sha1_jstring);

    //sha1.digest (certByte)
    methodId=env->GetMethodID(message_digest_class,"digest","([B)[B");
    jbyteArray sha1_byte=(jbyteArray)env->CallObjectMethod(sha1_digest,methodId,cert_byte);
    env->DeleteLocalRef(message_digest_class);

    //toHexString
    jsize array_size=env->GetArrayLength(sha1_byte);
    jbyte* sha1 =env->GetByteArrayElements(sha1_byte,NULL);
    char *hex_sha=new char[array_size*2+1];
    for (int i = 0; i <array_size ; ++i) {
        hex_sha[2*i]=HexCode[((unsigned char)sha1[i])/16];
        hex_sha[2*i+1]=HexCode[((unsigned char)sha1[i])%16];
    }
    hex_sha[array_size*2]='\0';
    //比较签名
    if (strcmp(hex_sha,app_signature_sha1)==0)
    {
        return true;
    } else{
       return false;
    }
}

JNIEXPORT void JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1authValidAPP
        (JNIEnv *env, jclass, jobject contextObject)
{
//    g_isAuth = (checkPkgName(env,  contextObject))&& (checkPkgSigHash(env,  contextObject));
    g_isAuth = true;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1EncByAES128CBC
        (JNIEnv *env, jclass, jbyteArray input, jshort inputLen, jbyteArray inputKEY, jbyteArray output)
{
    u8 *inputBuf;
    u8 * inputKEYBuf;
    u8 *outputBuf;
    jboolean result;
    int chars_len;

    //if(!g_isAuth) return false;
    inputBuf = ConvertJByteaArrayToChars(env,  input);
    inputKEYBuf = ConvertJByteaArrayToChars(env,  inputKEY);
    chars_len = (inputLen + 0x10)&0xFFFFFFF0;
    //outputBuf = new u8[chars_len];
    outputBuf = ConvertJByteaArrayToChars(env,  output);
    result = CoinID_EncByAES128CBC(inputBuf, inputLen, inputKEYBuf, outputBuf);
    env->SetByteArrayRegion(output, 0, chars_len, (jbyte*)outputBuf);
    return result;
}

JNIEXPORT jshort JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DecByAES128CBC
        (JNIEnv *env, jclass, jbyteArray input, jshort inputLen, jbyteArray inputKEY, jbyteArray output)
{
    u8 *inputBuf;
    u8 * inputKEYBuf;
    u8 *outputBuf;
    jboolean result;
    int chars_len;

    if(!g_isAuth) return 0;
    inputBuf = ConvertJByteaArrayToChars(env,  input);
    inputKEYBuf = ConvertJByteaArrayToChars(env,  inputKEY);
   // outputBuf = new u8[inputLen];
    outputBuf = ConvertJByteaArrayToChars(env,  output);
    chars_len = CoinID_DecByAES128CBC(inputBuf, inputLen, inputKEYBuf, outputBuf);
    env->SetByteArrayRegion(output, 0, chars_len, (jbyte*)outputBuf);
    return chars_len;
}

JNIEXPORT void JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genKeyPair
        (JNIEnv *env, jclass, jbyteArray prvKey, jbyteArray pubKey)
{
    int     dev_random_fd = -1;
    u8  randomBuf[32];
    u8 *prtRandomBuf;
    u8 bytes_to_read;
    u8 bytes_read;
    u8 prvKeyBuf[32];
    u8 pubKeyBuf[33];
    u8 result;

    if(!g_isAuth) return ;
    prtRandomBuf  = randomBuf;
    bytes_to_read   = 32;
    dev_random_fd = open("/dev/random", O_RDONLY);

    do
    {
        bytes_read = read(dev_random_fd, prtRandomBuf, bytes_to_read);
        bytes_to_read -= bytes_read;
        prtRandomBuf += bytes_read;
        result =  CoinID_genKeyPair(randomBuf, prvKeyBuf, pubKeyBuf);
    }while( (bytes_to_read > 0) && (!result) );


    env->SetByteArrayRegion(prvKey, 0, 32, (jbyte*)prvKeyBuf);
    env->SetByteArrayRegion(pubKey, 0, 33, (jbyte*)pubKeyBuf);
    return;
}

JNIEXPORT void JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1keyAgreement
        (JNIEnv *env, jclass, jbyteArray prvKey, jbyteArray pubKey, jbyteArray output)
{
    u8 *prvKeyBuf;
    u8 *pubKeyBuf;
    u8 *outputBuf;
    if(!g_isAuth) return ;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    outputBuf = ConvertJByteaArrayToChars(env,  output);
    CoinID_keyAgreement(prvKeyBuf, pubKeyBuf, outputBuf);

    env->SetByteArrayRegion(output, 0, 16, (jbyte*)outputBuf);
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ECDSA_1verify
        (JNIEnv *env, jclass, jbyteArray msg, jint length, jbyteArray sigData, jbyteArray pubKey)
{
    u8 *msgBuf;
    u8 *sigDataBuf;
    u8 *pubKeyBuf;
    jboolean result;
    if(!g_isAuth) return false;
    msgBuf = ConvertJByteaArrayToChars(env,  msg);
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);

    if(pubKey == nullptr)
    {
        result = CoinID_ECDSA_verify(msgBuf, length, sigDataBuf, (u8 *)coinid_pub);
    } else {
        pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
        result = CoinID_ECDSA_verify(msgBuf, length, sigDataBuf, pubKeyBuf);
    }
    return result;
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveKeyRoot
        (JNIEnv *, jclass, jint coinType)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveKeyRoot(coinType);
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveKeyAccount
        (JNIEnv *, jclass, jint index)
{
    if(!g_isAuth) return false;
    return CoinID_DeriveKeyAccount(index);
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveKey
        (JNIEnv *env, jclass, jint index)
{
    jbyteArray jbarr;
    u8 *outKey;
    if(!g_isAuth) return NULL;
    jbarr = env->NewByteArray(128);
    outKey =  CoinID_DeriveKey(index);
    if(!outKey) return NULL;
    env->SetByteArrayRegion(jbarr, 0, 128, (jbyte*)outKey);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBYTOMAddress
        (JNIEnv *env, jclass, jbyteArray pubkey)
{
    u8 *pubkeyBuf;
    jbyteArray jbarr;
    u8 *output;
    u8 len;
    if(!g_isAuth) return NULL;
    pubkeyBuf = ConvertJByteaArrayToChars(env,  pubkey);
    output = CoinID_getBYTOMAddress(pubkeyBuf);
    len = strlen((char *)output);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)output);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtBYTOMTransaction
        (JNIEnv *env, jclass, jbyteArray json, jbyteArray prvKey)
{
    jbyteArray jbarr;
    u16 len;
    u8 *jbarrBuf;
    u8 *jsonBuf;
    u8 *prvKeyBuf;
    if(!g_isAuth) return NULL;
    jsonBuf = ConvertJByteaArrayToChars(env,  json);
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);

    jbarrBuf = CoinID_sigtBYTOMTransaction((u8 *)jsonBuf, (u8 *)prvKeyBuf);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBYTOMTranJSON
        (JNIEnv *env, jclass, jbyteArray json, jbyteArray outLen)
{
    u8 *jsonBuf;
    u8 *outLenBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonBuf = ConvertJByteaArrayToChars(env,  json);
    outLenBuf = ConvertJByteaArrayToChars(env,  outLen);

    jbarrBuf = CoinID_serializeBYTOMTranJSON((u8 *)jsonBuf, (u8 *)outLenBuf);
    env->SetByteArrayRegion(outLen, 0,2 , (jbyte*)outLenBuf);
    len = (outLenBuf[0]<<8)|outLenBuf[1];
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBYTOMTranJson
        (JNIEnv *env, jclass, jbyteArray sigOut, jshort length)
{
    u8 *sigOutBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    sigOutBuf = ConvertJByteaArrayToChars(env,  sigOut);

    jbarrBuf = CoinID_packBYTOMTranJson((u8 *)sigOutBuf, length);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);

    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1importKeyStore
        (JNIEnv *env, jclass, jbyteArray json, jbyteArray passwd, jbyte passLen, jbyteArray outLen)
{
    u8 *jsonBuf;
    u8 *passwdBuf;
    u8 *outLenBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonBuf = ConvertJByteaArrayToChars(env,  json);
    passwdBuf = ConvertJByteaArrayToChars(env,  passwd);
    outLenBuf = ConvertJByteaArrayToChars(env,  outLen);

    jbarrBuf = CoinID_importKeyStore((u8 *)jsonBuf, (u8 *)passwdBuf, passLen, (u8 *)outLenBuf);
    env->SetByteArrayRegion(outLen, 0,2 , (jbyte*)outLenBuf);
    len = (outLenBuf[0]<<8)|outLenBuf[1];
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1exportKeyStore
        (JNIEnv *env, jclass, jbyteArray prvKey, jbyte keyLen, jbyte type, jbyteArray passwd, jbyte passLen, jbyteArray salt, jbyteArray iv, jbyteArray uuid)
{
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    u8 *prvKeyBuf;
    u8 *passwdBuf;
    u8 *saltBuf;
    u8 *ivBuf;
    u8 *uuidBuf;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    passwdBuf = ConvertJByteaArrayToChars(env,  passwd);
    saltBuf = ConvertJByteaArrayToChars(env,  salt);
    ivBuf = ConvertJByteaArrayToChars(env,  iv);
    uuidBuf = ConvertJByteaArrayToChars(env,  uuid);
   jbarrBuf = CoinID_exportKeyStore((u8 *)prvKeyBuf, keyLen, type, (u8 *)passwdBuf, passLen, (u8 *)saltBuf, (u8 *)ivBuf, (u8 *)uuidBuf);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBYTOMCode
        (JNIEnv *env, jclass, jbyteArray address)
{
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u8 *addressBuf;
    u16 len;
    if(!g_isAuth) return NULL;
    addressBuf = ConvertJByteaArrayToChars(env,  address);
    jbarrBuf = CoinID_getBYTOMCode((u8 *)addressBuf);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}
JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportBYTOMPrvKey
        (JNIEnv *env, jclass, jbyteArray prvKey)
{
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u8 *prvKeyBuf;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    jbarrBuf = CoinID_ImportBYTOMPrvKey((u8 *)prvKeyBuf);
    jbarr = env->NewByteArray(128);
    env->SetByteArrayRegion(jbarr, 0,128 , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeTranJSONOnly
        (JNIEnv *env, jclass, jbyteArray jsonTran, jbyteArray msgLength)
{
    u8 *jsonTranBuf;
    u8 *msgLengthBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    msgLengthBuf = ConvertJByteaArrayToChars(env,  msgLength);
    jbarrBuf = CoinID_serializeTranJSONOnly(jsonTranBuf, msgLengthBuf);
    env->SetByteArrayRegion(msgLength, 0,2 , (jbyte*)msgLengthBuf);
    len = (msgLengthBuf[0]<<8)|(msgLengthBuf[1]);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packTranJsonOnly
        (JNIEnv *env, jclass, jbyteArray sigData, jint recid)
{
    u8 *sigDataBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    jbarrBuf = CoinID_packTranJsonOnly(sigDataBuf, recid);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBTCTranJSONOnly
        (JNIEnv *env, jclass, jbyteArray jsonTran, jbyteArray pubKey, jbyteArray outLen)
{
    u8 *jsonTranBuf;
    u8 *pubKeyBuf;
    u8 *outLenBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    outLenBuf = ConvertJByteaArrayToChars(env,  outLen);
    jbarrBuf = CoinID_serializeBTCTranJSONOnly(jsonTranBuf, pubKeyBuf, outLenBuf);
    env->SetByteArrayRegion(outLen, 0,2 , (jbyte*)outLenBuf);
    len = (outLenBuf[0]<<8)|(outLenBuf[1]);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTCTranJsonOnly
        (JNIEnv *env, jclass, jbyteArray sigData, jint length, jbyteArray pubKey)
{
    u8 *sigDataBuf;
    u8 *pubKeyBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    pubKeyBuf = ConvertJByteaArrayToChars(env,  pubKey);
    jbarrBuf = CoinID_packBTCTranJsonOnly(sigDataBuf, length, pubKeyBuf);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBYTOMTranJSONOnly
        (JNIEnv * env, jclass, jbyteArray jsonTran, jbyteArray outLen)
{
    u8 *jsonTranBuf;
    u8 *outLenBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    jsonTranBuf = ConvertJByteaArrayToChars(env,  jsonTran);
    outLenBuf = ConvertJByteaArrayToChars(env,  outLen);
    jbarrBuf = CoinID_serializeBYTOMTranJSONOnly(jsonTranBuf, outLenBuf);
    env->SetByteArrayRegion(outLen, 0,2 , (jbyte*)outLenBuf);
    len = (outLenBuf[0]<<8)|(outLenBuf[1]);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBYTOMTranJsonOnly
        (JNIEnv *env, jclass, jbyteArray sigData, jshort length)
{
    u8 *sigDataBuf;
    u8 *pubKeyBuf;
    u8 *jbarrBuf;
    jbyteArray jbarr;
    u16 len;
    if(!g_isAuth) return NULL;
    sigDataBuf = ConvertJByteaArrayToChars(env,  sigData);
    jbarrBuf = CoinID_packBYTOMTranJsonOnly(sigDataBuf, length);
    len = strlen((char *)jbarrBuf);
    jbarr = env->NewByteArray(len);
    env->SetByteArrayRegion(jbarr, 0,len , (jbyte*)jbarrBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportPrvKeyByWIF
(JNIEnv *env, jclass, jbyteArray prvKey, jshort length)
{
    u8 *prvKeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    packDataBuf =  CoinID_ImportPrvKeyByWIF(prvKeyBuf,length);
    if(!packDataBuf ) return NULL;
    jbarr = env->NewByteArray(97);
    env->SetByteArrayRegion(jbarr, 0, 97, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportPrvKeyByWIF
(JNIEnv *env, jclass, jbyte prefix,jbyteArray prvKey)
{
    u8 *prvKeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    int i=0;
    if(!g_isAuth) return NULL;
    prvKeyBuf = ConvertJByteaArrayToChars(env,  prvKey);
    packDataBuf =  CoinID_ExportPrvKeyByWIF(prefix, prvKeyBuf);
    while(packDataBuf[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}

JNIEXPORT jbyteArray JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBCHAddress
        (JNIEnv *env, jclass, jbyteArray pubkey)
{
    u8 *pubkeyBuf;
    jbyteArray jbarr;
    u8 *packDataBuf;
    int i=0;
    if(!g_isAuth) return NULL;
    pubkeyBuf = ConvertJByteaArrayToChars(env,  pubkey);
    packDataBuf =  CoinID_getBCHAddress(pubkeyBuf);
    while(packDataBuf[i]!='\0') i++;
    jbarr = env->NewByteArray(i);
    env->SetByteArrayRegion(jbarr, 0, i, (jbyte*)packDataBuf);
    return jbarr;
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigETH_1TX_1by_1str
        (JNIEnv *env, jclass, jstring p_nonce, jstring p_gasprice, jstring p_startgas, jstring to, jstring p_value, jstring p_data, jstring p_chainId, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *p_nonceStr = env->GetStringUTFChars(p_nonce,0);
    const char *p_gaspriceStr = env->GetStringUTFChars(p_gasprice,0);
    const char *p_startgasStr = env->GetStringUTFChars(p_startgas,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *p_valueStr = env->GetStringUTFChars(p_value,0);
    const char *p_dataStr = env->GetStringUTFChars(p_data,0);
    const char *p_chainIdStr = env->GetStringUTFChars(p_chainId,0);
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_sigETH_TX_by_str(p_nonceStr, p_gaspriceStr, p_startgasStr, toStr, p_valueStr, p_dataStr, p_chainIdStr, prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serETH_1TX_1by_1str
        (JNIEnv *env, jclass, jstring p_nonce, jstring p_gasprice, jstring p_startgas, jstring to, jstring p_value, jstring p_data, jstring p_chainId, jbyteArray sigHash)
{
    u8 sigH[32];
    if(!g_isAuth) return NULL;
    const char *p_nonceStr = env->GetStringUTFChars(p_nonce,0);
    const char *p_gaspriceStr = env->GetStringUTFChars(p_gasprice,0);
    const char *p_startgasStr = env->GetStringUTFChars(p_startgas,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *p_valueStr = env->GetStringUTFChars(p_value,0);
    const char *p_dataStr = env->GetStringUTFChars(p_data,0);
    const char *p_chainIdStr = env->GetStringUTFChars(p_chainId,0);
    string pushStr = CoinID_serETH_TX_by_str(p_nonceStr, p_gaspriceStr, p_startgasStr, toStr, p_valueStr, p_dataStr, p_chainIdStr, sigH);
    env->SetByteArrayRegion(sigHash, 0, 32, (jbyte*)sigH);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packETH_1TX_1by_1str
        (JNIEnv *env, jclass, jstring sigOut, jstring sigData, jint recid, jstring p_chainId)
{
    if(!g_isAuth) return NULL;
    const char *sigOutStr = env->GetStringUTFChars(sigOut,0);
    const char *sigDataStr = env->GetStringUTFChars(sigData,0);
    const char *p_chainIdStr = env->GetStringUTFChars(p_chainId,0);
    string pushStr = CoinID_packETH_TX_by_str(sigOutStr, sigDataStr, recid, p_chainIdStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkETHpushValid
        (JNIEnv *env, jclass, jstring pushStr, jstring to, jstring value, jint decimal, jboolean isContract, jstring contractAddr)
{
    if(!g_isAuth) return false;
    const char *pushStrStr = env->GetStringUTFChars(pushStr,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *valueStr = env->GetStringUTFChars(value,0);
    const char *contractAddrStr = env->GetStringUTFChars(contractAddr,0);
    return CoinID_checkETHpushValid(pushStrStr,toStr,valueStr,decimal,isContract,contractAddrStr);
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1SetMasterStandard
        (JNIEnv *env, jclass, jstring mnemonicBuffer)
{
    if(!g_isAuth) return false;
    const char *mnemonicBufferStr = env->GetStringUTFChars(mnemonicBuffer,0);
    return CoinID_SetMasterStandard(mnemonicBufferStr);
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1deriveKeyByPath
        (JNIEnv *env, jclass, jstring path)
{
    if(!g_isAuth) return NULL;
    const char *pathStr = env->GetStringUTFChars(path,0);
    string pushStr = CoinID_deriveKeyByPath(pathStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1GetVersion
        (JNIEnv *env, jclass)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_GetVersion();
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkEOSpushValid
        (JNIEnv *env, jclass, jstring pushStr, jstring to, jstring value, jstring unit)
{
    if(!g_isAuth) return false;
    const char *pushStrStr = env->GetStringUTFChars(pushStr,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *valueStr = env->GetStringUTFChars(value,0);
    const char *unitStr = env->GetStringUTFChars(unit,0);
    return CoinID_checkEOSpushValid(pushStrStr, toStr, valueStr,unitStr );
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkBTCpushValid
        (JNIEnv *env, jclass, jstring pushStr, jstring to, jstring toValue, jstring from, jstring fromValue, jstring usdtValue, jstring coinType, jboolean isSegwit)
{
    if(!g_isAuth) return false;
    const char *pushStrStr = env->GetStringUTFChars(pushStr,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *toValueStr = env->GetStringUTFChars(toValue,0);
    const char *fromStr = env->GetStringUTFChars(from,0);
    const char *fromValueStr = env->GetStringUTFChars(fromValue,0);
    const char *usdtValueStr = env->GetStringUTFChars(usdtValue,0);
    const char *coinTypeStr = env->GetStringUTFChars(coinType,0);
    return CoinID_checkBTCpushValid(pushStrStr, toStr, toValueStr,fromStr,  fromValueStr, usdtValueStr, coinTypeStr, isSegwit);
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkBYTOMpushValid
        (JNIEnv *env, jclass, jstring pushStr, jstring to, jstring toValue, jstring from, jstring fromValue)
{
    if(!g_isAuth) return false;
    const char *pushStrStr = env->GetStringUTFChars(pushStr,0);
    const char *toStr = env->GetStringUTFChars(to,0);
    const char *toValueStr = env->GetStringUTFChars(toValue,0);
    const char *fromStr = env->GetStringUTFChars(from,0);
    const char *fromValueStr = env->GetStringUTFChars(fromValue,0);
    return CoinID_checkBYTOMpushValid(pushStrStr, toStr, toValueStr,fromStr,  fromValueStr);
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1SHA256
        (JNIEnv *env, jclass, jstring input)
{
    if(!g_isAuth) return NULL;
    const char *inputStr = env->GetStringUTFChars(input,0);
    string pushStr = CoinID_SHA256(inputStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkAddressValid
        (JNIEnv *env, jclass, jstring chainType, jstring address)
{
    if(!g_isAuth) return false;
    const char *chainTypeStr = env->GetStringUTFChars(chainType,0);
    const char *addressStr = env->GetStringUTFChars(address,0);
    return CoinID_checkAddressValid(chainTypeStr, addressStr);
}
JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1checkCrossChain
        (JNIEnv *env, jclass, jstring coinType, jstring pushStr, jstring contractAddr, jstring chainName, jstring tokenid, jstring account, jstring amout, jint decimal, jstring unit)

{
    if(!g_isAuth) return false;
    const char *coinTypeStr = env->GetStringUTFChars(coinType,0);
    const char *pushStrStr = env->GetStringUTFChars(pushStr,0);
    const char *contractAddrStr = env->GetStringUTFChars(contractAddr,0);
    const char *chainNameStr = env->GetStringUTFChars(chainName,0);
    const char *tokenidStr = env->GetStringUTFChars(tokenid,0);
    const char *accountStr = env->GetStringUTFChars(account,0);
    const char *amoutStr = env->GetStringUTFChars(amout,0);
    const char *unitStr = env->GetStringUTFChars(unit,0);
    return CoinID_checkCrossChain(coinTypeStr, pushStrStr, contractAddrStr, chainNameStr, tokenidStr, accountStr, amoutStr,  decimal,unitStr);
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1EncPhoneNum
        (JNIEnv *env, jclass, jstring number)
{
    if(!g_isAuth) return NULL;
    const char *numberStr = env->GetStringUTFChars(number,0);
    string pushStr = CoinID_EncPhoneNum( numberStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DecPhoneNum
        (JNIEnv *env, jclass, jstring number)
{
    if(!g_isAuth) return NULL;
    const char *numberStr = env->GetStringUTFChars(number,0);
    string pushStr = CoinID_DecPhoneNum( numberStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportEOSPubByPre
        (JNIEnv *env, jclass , jstring prefix, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *prefixStr = env->GetStringUTFChars(prefix,0);
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_ExportEOSPubByPre(prefixStr, pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1cvtAddrByEIP55
        (JNIEnv *env, jclass, jstring addr)
{
    if(!g_isAuth) return NULL;
    const char *addrStr = env->GetStringUTFChars(addr,0);
    string pushStr = CoinID_cvtAddrByEIP55(addrStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveEOSKeyStr
        (JNIEnv *env, jclass, jint index)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_DeriveEOSKeyStr(index);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveETHKeyStr
        (JNIEnv *env, jclass, jint index)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_DeriveETHKeyStr(index);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportEOSPubKeyStr
        (JNIEnv *env, jclass, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_ExportEOSPubKeyStr(pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportEOSPrvKeyStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ExportEOSPrvKeyStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ParseEOSPubKeyStr
        (JNIEnv *env, jclass, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_ParseEOSPubKeyStr(pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportEOSPrvKeyCheckStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return false;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    return CoinID_ImportEOSPrvKeyCheckStr(prvKeyStr);
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportEOSPrvKeyStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ImportEOSPrvKeyStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1GetTranSigJsonStr
        (JNIEnv *env, jclass, jstring jsonTran, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_GetTranSigJsonStr(jsonTranStr, prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportETHPubKeyStr
        (JNIEnv *env, jclass, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_ExportETHPubKeyStr(pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getMasterPubKeyStr
        (JNIEnv *env, jclass)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_getMasterPubKeyStr();
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeTranJSONStr
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_serializeTranJSONStr(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packTranJsonStr
        (JNIEnv *env, jclass, jstring sigData, jint recid)
{
    if(!g_isAuth) return NULL;
    const char *sigDataStr = env->GetStringUTFChars(sigData,0);
    string pushStr = CoinID_packTranJsonStr(sigDataStr, recid);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genBTCAddressStr
        (JNIEnv *env, jclass, jbyte prefix, jstring pubKey, jbyte type)
{
    if(!g_isAuth) return NULL;
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_genBTCAddressStr(prefix, pubKeyStr, type);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtBTCTransactionStr
        (JNIEnv *env, jclass, jstring jsonTran, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_sigtBTCTransactionStr(jsonTranStr, prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportETHPrvKeyStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ImportETHPrvKeyStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveBTCKeyStr
        (JNIEnv *env, jclass, jint index)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_DeriveBTCKeyStr(index);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportBTCPrvKeyByWIFStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ImportBTCPrvKeyByWIFStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportBTCPrvKeyByWIFStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ExportBTCPrvKeyByWIFStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genScriptHashStr
        (JNIEnv *env, jclass, jstring address)
{
    if(!g_isAuth) return NULL;
    const char *addressStr = env->GetStringUTFChars(address,0);
    string pushStr = CoinID_genScriptHashStr(addressStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBTCTranJSONStr
        (JNIEnv *env, jclass, jstring jsonTran, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_serializeBTCTranJSONStr(jsonTranStr, pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTCTranJsonStr
        (JNIEnv *env, jclass, jboolean isSegwit, jstring sigData, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *sigDataStr = env->GetStringUTFChars(sigData,0);
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_packBTCTranJsonStr(isSegwit, sigDataStr, pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1DeriveKeyStr
        (JNIEnv *env, jclass, jint index)
{
    if(!g_isAuth) return NULL;
    string pushStr = CoinID_DeriveKeyStr(index);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBYTOMAddressStr
        (JNIEnv *env, jclass, jstring pubkey)
{
    if(!g_isAuth) return NULL;
    const char *pubkeyStr = env->GetStringUTFChars(pubkey,0);
    string pushStr = CoinID_getBYTOMAddressStr(pubkeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtBYTOMTransactionStr
        (JNIEnv *env, jclass, jstring jsonTran, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_sigtBYTOMTransactionStr(jsonTranStr, prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBYTOMTranJSONStr
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_serializeBYTOMTranJSONStr(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBYTOMTranJsonStr
        (JNIEnv *env, jclass, jstring sigOut)
{
    if(!g_isAuth) return NULL;
    const char *sigOutStr = env->GetStringUTFChars(sigOut,0);
    string pushStr = CoinID_packBYTOMTranJsonStr(sigOutStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1importKeyStoreStr
        (JNIEnv *env, jclass, jstring json, jstring passwd)
{
    if(!g_isAuth) return NULL;
    const char *jsonStr = env->GetStringUTFChars(json,0);
    const char *passwdStr = env->GetStringUTFChars(passwd,0);
    string pushStr = CoinID_importKeyStoreStr(jsonStr, passwdStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1exportKeyStoreStr
        (JNIEnv *env, jclass, jstring prvKey , jbyte type, jstring passwd, jstring salt, jstring iv, jstring uuid)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    const char *passwdStr = env->GetStringUTFChars(passwd,0);
    const char *saltStr = env->GetStringUTFChars(salt,0);
    const char *ivStr = env->GetStringUTFChars(iv,0);
    const char *uuidStr = env->GetStringUTFChars(uuid,0);
    string pushStr = CoinID_exportKeyStoreStr(prvKeyStr, type, passwdStr, saltStr, ivStr,uuidStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBYTOMCodeStr
        (JNIEnv *env, jclass, jstring address)
{
    if(!g_isAuth) return NULL;
    const char *addressStr = env->GetStringUTFChars(address,0);
    string pushStr = CoinID_getBYTOMCodeStr(addressStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportBYTOMPrvKeyStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ImportBYTOMPrvKeyStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeTranJSONOnlyStr
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_serializeTranJSONOnlyStr(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packTranJsonOnlyStr
        (JNIEnv *env, jclass, jstring sigData, jint recid)
{
    if(!g_isAuth) return NULL;
    const char *sigDataStr = env->GetStringUTFChars(sigData,0);
    string pushStr = CoinID_packTranJsonOnlyStr(sigDataStr, recid);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBTCTranJSONOnlyStr
        (JNIEnv *env, jclass, jstring jsonTran, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_serializeBTCTranJSONOnlyStr(jsonTranStr, pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTCTranJsonOnlyStr
        (JNIEnv *env, jclass, jstring sigData, jstring pubKey)
{
    if(!g_isAuth) return NULL;
    const char *sigDataStr = env->GetStringUTFChars(sigData,0);
    const char *pubKeyStr = env->GetStringUTFChars(pubKey,0);
    string pushStr = CoinID_packBTCTranJsonOnlyStr(sigDataStr, pubKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serializeBYTOMTranJSONOnlyStr
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_serializeBYTOMTranJSONOnlyStr(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBYTOMTranJsonOnlyStr
        (JNIEnv *env, jclass, jstring sigOut)
{
    if(!g_isAuth) return NULL;
    const char *sigOutStr = env->GetStringUTFChars(sigOut,0);
    string pushStr = CoinID_packBYTOMTranJsonOnlyStr(sigOutStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ImportPrvKeyByWIFStr
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ImportPrvKeyByWIFStr(prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1ExportPrvKeyByWIFStr
        (JNIEnv *env, jclass, jbyte prefix, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pushStr = CoinID_ExportPrvKeyByWIFStr(prefix, prvKeyStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBCHAddressStr
        (JNIEnv *env, jclass, jstring pubkey)
{
        if(!g_isAuth) return NULL;
        const char *pubkeyStr = env->GetStringUTFChars(pubkey,0);
        string pushStr = CoinID_getBCHAddressStr(pubkeyStr);
        return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBTMMultSigInfo
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_getBTMMultSigInfo(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1createBTMMultAddr
        (JNIEnv *env, jclass, jstring prefix, jstring pubkeys, jint quorum)
{
    if(!g_isAuth) return NULL;
    const char *prefixStr = env->GetStringUTFChars(prefix,0);
    const char *pubkeysStr = env->GetStringUTFChars(pubkeys,0);
    string pushStr = CoinID_createBTMMultAddr(prefixStr, pubkeysStr, quorum);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTMMultSigInfo
        (JNIEnv *env, jclass, jstring jsonTran, jstring jsonWitness)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *jsonWitnessStr = env->GetStringUTFChars(jsonWitness,0);
    string pushStr = CoinID_packBTMMultSigInfo(jsonTranStr, jsonWitnessStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBTMMultSigSignature
        (JNIEnv *env, jclass, jstring msgs, jstring key, jboolean needSig)
{
    if(!g_isAuth) return NULL;
    const char *msgsStr = env->GetStringUTFChars(msgs,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    string pushStr = CoinID_getBTMMultSigSignature(msgsStr, keyStr, needSig);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1BTMMSSignature
        (JNIEnv *env, jclass, jstring msg, jstring key)
{
    if(!g_isAuth) return NULL;
    const char *msgStr = env->GetStringUTFChars(msg,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    string pushStr = CoinID_BTMMSSignature(msgStr, keyStr);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1BTMMSVerify
        (JNIEnv *env, jclass, jstring msg, jstring key, jstring signature)
{
    if(!g_isAuth) return false;
    const char *msgStr = env->GetStringUTFChars(msg,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    const char *signatureStr = env->GetStringUTFChars(signature,0);
    return CoinID_BTMMSVerify(msgStr, keyStr,signatureStr);
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBTCMultSigInfo
        (JNIEnv *env, jclass, jstring jsonTran , jstring pubKeys, jint quorum)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *pubKeysStr = env->GetStringUTFChars(pubKeys,0);
    string pushStr = CoinID_getBTCMultSigInfo(jsonTranStr, pubKeysStr, quorum);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1createBTCMultAddr
        (JNIEnv *env, jclass, jbyte prefix, jstring pubkeys, jint quorum)
{
    if(!g_isAuth) return NULL;
    const char *pubKeysStr = env->GetStringUTFChars(pubkeys,0);
    string pushStr = CoinID_createBTCMultAddr(prefix, pubKeysStr, quorum);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1packBTCMultSigInfo
        (JNIEnv *env, jclass, jstring jsonTran, jstring jsonWitness, jstring pubkeys, jint quorum)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *jsonWitnessStr = env->GetStringUTFChars(jsonWitness,0);
    const char *pubKeysStr = env->GetStringUTFChars(pubkeys,0);
    string pushStr = CoinID_packBTCMultSigInfo(jsonTranStr, jsonWitnessStr,pubKeysStr, quorum);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getBTCMultSigSignature
        (JNIEnv *env, jclass, jstring msgs , jstring key, jboolean needSig)
{
    if(!g_isAuth) return NULL;
    const char *msgsStr = env->GetStringUTFChars(msgs,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    string pushStr = CoinID_getBTCMultSigSignature(msgsStr, keyStr,needSig);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1BTCMSSignature
        (JNIEnv *env, jclass, jstring msg, jstring key)
{
    if(!g_isAuth) return NULL;
    const char *msgStr = env->GetStringUTFChars(msg,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    string pushStr = CoinID_BTCMSSignature(msgStr, keyStr);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jboolean JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1BTCMSVerify
        (JNIEnv *env, jclass, jstring msg, jstring key, jstring signature)
{
    if(!g_isAuth) return false;
    const char *msgStr = env->GetStringUTFChars(msg,0);
    const char *keyStr = env->GetStringUTFChars(key,0);
    const char *signatureStr = env->GetStringUTFChars(signature,0);
    return CoinID_BTCMSVerify(msgStr, keyStr, signatureStr);
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serBTMMS
        (JNIEnv *env, jclass, jstring jsonTran)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    string pushStr = CoinID_serBTMMS(jsonTranStr);
    return env->NewStringUTF(pushStr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1serBTCMS
        (JNIEnv *env, jclass, jstring jsonTran, jstring pubKeys, jint quorum)
{
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *pubKeysStr = env->GetStringUTFChars(pubKeys,0);
    string pushStr = CoinID_serBTCMS(jsonTranStr, pubKeysStr, quorum);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1filterUTXO
        (JNIEnv *env, jclass, jstring utxoJson, jstring amount, jstring fee, jint quorum, jint num, jstring type)
{
    if(!g_isAuth) return NULL;
    const char *utxoJsonStr = env->GetStringUTFChars(utxoJson,0);
    const char *amountStr = env->GetStringUTFChars(amount,0);
    const char *feeStr = env->GetStringUTFChars(fee,0);
    const char *typeStr = env->GetStringUTFChars(type,0);
    string pushStr = CoinID_filterUTXO(utxoJsonStr, amountStr, feeStr,  quorum, num, typeStr);
    return env->NewStringUTF(pushStr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getXMRAddress
        (JNIEnv *env, jclass, jstring nettype, jstring pubSpendKey, jstring pubViewKey, jstring short_pid)
{
    if(!g_isAuth) return NULL;
    const char *nettypeStr = env->GetStringUTFChars(nettype,0);
    const char *pubSpendKeyStr = env->GetStringUTFChars(pubSpendKey,0);
    const char *pubViewKeyStr = env->GetStringUTFChars(pubViewKey,0);
    const char *short_pidStr = env->GetStringUTFChars(short_pid,0);
    string address = CoinID_getXMRAddress(nettypeStr, pubSpendKeyStr, pubViewKeyStr, short_pidStr);
    return env->NewStringUTF(address.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getXMRViewBySpend
        (JNIEnv *env, jclass, jstring prvSpendKey)
{
    if(!g_isAuth) return NULL;
    const char *prvSpendKeyStr = env->GetStringUTFChars(prvSpendKey,0);
    string viewkey = CoinID_getXMRPubByPrv(prvSpendKeyStr);
    return env->NewStringUTF(viewkey.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getXMRPubByPrv
        (JNIEnv *env, jclass, jstring prvKey)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStr = env->GetStringUTFChars(prvKey,0);
    string pubkey = CoinID_getXMRPubByPrv(prvKeyStr);
    return env->NewStringUTF(pubkey.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigtMoneroTransaction
        (JNIEnv *env, jclass, jstring unspent_outsStr, jstring mix_outsStr, jstring prvSpendKey, jstring prvViewKey)
{
    if(!g_isAuth) return NULL;
    const char *unspent_outsStrStr = env->GetStringUTFChars(unspent_outsStr,0);
    const char *mix_outsStrStr = env->GetStringUTFChars(mix_outsStr,0);
    const char *prvSpendKeyStr = env->GetStringUTFChars(prvSpendKey,0);
    const char *prvViewKeyStr = env->GetStringUTFChars(prvViewKey,0);
    string pushstr = CoinID_sigtMoneroTransaction(unspent_outsStrStr, mix_outsStrStr, prvSpendKeyStr, prvViewKeyStr);
    return env->NewStringUTF(pushstr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1searchXMRTX
        (JNIEnv *env, jclass, jstring spdPrv, jstring viewPrv, jstring txData)
{
    if(!g_isAuth) return NULL;
    const char *spdPrvStr = env->GetStringUTFChars(spdPrv,0);
    const char *viewPrvStr = env->GetStringUTFChars(viewPrv,0);
    const char *txDataStr = env->GetStringUTFChars(txData,0);
    string pushstr = CoinID_searchXMRTX(spdPrvStr, viewPrvStr, txDataStr);
    return env->NewStringUTF(pushstr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1CRC16_1CCITT_1FALSE
        (JNIEnv *env, jclass, jstring input)
{
    if(!g_isAuth) return NULL;
    const char *inputStr = env->GetStringUTFChars(input,0);

    string pushstr = CoinID_CRC16_CCITT_FALSE(inputStr);
    return env->NewStringUTF(pushstr.c_str());
}

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1genPolkaDotKeyPairByPath
  (JNIEnv *env, jclass, jshortArray mnemonicIndexBuffer, jint indexLen, jstring path)
  {
    if(!g_isAuth) return NULL;
    u16 *memoIndexBuf;
        memoIndexBuf = ConvertJShortArrayToShort(env,  mnemonicIndexBuffer);
       const char *pathStr = env->GetStringUTFChars(path,0);
       string pushstr = CoinID_genPolkaDotKeyPairByPath(memoIndexBuf, indexLen, pathStr);
       return env->NewStringUTF(pushstr.c_str());
  }

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getPolkaDotAddress
  (JNIEnv *env, jclass, jbyte prefix, jstring pubkeyStr)
  {
    if(!g_isAuth) return NULL;
    const char *pubkeyStrStr = env->GetStringUTFChars(pubkeyStr,0);
   string pushstr = CoinID_getPolkaDotAddress(prefix, pubkeyStrStr);
   return env->NewStringUTF(pushstr.c_str());
  }

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1sigPolkadotTransaction
  (JNIEnv *env, jclass, jstring jsonTran, jstring prvKeyStr, jstring pubKeyStr)
  {
    if(!g_isAuth) return NULL;
    const char *jsonTranStr = env->GetStringUTFChars(jsonTran,0);
    const char *prvKeyStrStr = env->GetStringUTFChars(prvKeyStr,0);
    const char *pubKeyStrStr = env->GetStringUTFChars(pubKeyStr,0);
   string pushstr = CoinID_sigPolkadotTransaction(jsonTranStr, prvKeyStrStr,pubKeyStrStr);
   return env->NewStringUTF(pushstr.c_str());
  }

JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1polkadot_1ept_1keystore
        (JNIEnv *env, jclass, jstring password, jstring prvKeyStr, jbyte prefix, jstring pubKeyStr)
{
    if(!g_isAuth) return NULL;
    const char *passwordStr = env->GetStringUTFChars(password,0);
    const char *prvKeyStrStr = env->GetStringUTFChars(prvKeyStr,0);
    const char *pubKeyStrStr = env->GetStringUTFChars(pubKeyStr,0);
    string pushstr = CoinID_polkadot_ept_keystore(passwordStr, prvKeyStrStr,prefix,pubKeyStrStr);
    return env->NewStringUTF(pushstr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1polkadot_1ipt_1keystore
        (JNIEnv *env, jclass, jstring password, jstring keystore)
{
    if(!g_isAuth) return NULL;
    const char *passwordStr = env->GetStringUTFChars(password,0);
    const char *keystoreStr = env->GetStringUTFChars(keystore,0);
    string pushstr = CoinID_polkadot_ipt_keystore(passwordStr, keystoreStr);
    return env->NewStringUTF(pushstr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1getPolkaPubByPriv
        (JNIEnv *env, jclass, jstring prvKeyStr)
{
    if(!g_isAuth) return NULL;
    const char *prvKeyStrStr = env->GetStringUTFChars(prvKeyStr,0);
    string pushstr = CoinID_getPolkaPubByPriv(prvKeyStrStr);
    return env->NewStringUTF(pushstr.c_str());
}
JNIEXPORT jstring JNICALL Java_com_fictitious_money_purse_utils_XMHCoinUtitls_CoinID_1polkadot_1getNonceKey
        (JNIEnv *env, jclass, jstring address)
{
    if(!g_isAuth) return NULL;
    const char *addressStr = env->GetStringUTFChars(address,0);
    string pushstr = CoinID_polkadot_getNonceKey(addressStr);
    return env->NewStringUTF(pushstr.c_str());
}