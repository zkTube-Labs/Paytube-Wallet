package com.fictitious.money.purse.utils;

public class HexUtil {
    private static final char[] DIGITS_LOWER = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'};
    private static final char[] DIGITS_UPPER = new char[]{'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'};

    public HexUtil() {
    }

    public static char[] encodeHex(byte[] data) {
        return encodeHex(data, true);
    }

    public static char[] encodeHex(byte[] data, boolean toLowerCase) {
        return encodeHex(data, toLowerCase?DIGITS_LOWER:DIGITS_UPPER);
    }

    protected static char[] encodeHex(byte[] data, char[] toDigits) {
        if(data == null) {
            return null;
        } else {
            int l = data.length;
            char[] out = new char[l << 1];
            int i = 0;

            for(int var5 = 0; i < l; ++i) {
                out[var5++] = toDigits[(240 & data[i]) >>> 4];
                out[var5++] = toDigits[15 & data[i]];
            }

            return out;
        }
    }

    public static String encodeHexStr(byte[] data) {
        return encodeHexStr(data, true);
    }

    public static String encodeHexStr(byte[] data, boolean toLowerCase) {
        return encodeHexStr(data, toLowerCase?DIGITS_LOWER:DIGITS_UPPER);
    }

    protected static String encodeHexStr(byte[] data, char[] toDigits) {
        return new String(encodeHex(data, toDigits));
    }

    public static String formatHexString(byte[] data) {
        return formatHexString(data, false);
    }

    public static String formatHexString(byte[] data, boolean addSpace) {
        if(data != null && data.length >= 1) {
            StringBuilder sb = new StringBuilder();

            for(int i = 0; i < data.length; ++i) {
                String hex = Integer.toHexString(data[i] & 255);
                if(hex.length() == 1) {
                    hex = '0' + hex;
                }

                sb.append(hex);
                if(addSpace) {
                    sb.append(" ");
                }
            }

            return sb.toString().trim();
        } else {
            return null;
        }
    }

    public static byte[] decodeHex(char[] data) {
        int len = data.length;
        if((len & 1) != 0) {
            throw new RuntimeException("Odd number of characters.");
        } else {
            byte[] out = new byte[len >> 1];
            int i = 0;

            for(int j = 0; j < len; ++i) {
                int f = toDigit(data[j], j) << 4;
                ++j;
                f |= toDigit(data[j], j);
                ++j;
                out[i] = (byte)(f & 255);
            }

            return out;
        }
    }

    protected static int toDigit(char ch, int index) {
        int digit = Character.digit(ch, 16);
        if(digit == -1) {
            throw new RuntimeException("Illegal hexadecimal character " + ch + " at index " + index);
        } else {
            return digit;
        }
    }

    public static byte[] hexStringToBytes(String hexString) {
        if(hexString != null && !hexString.equals("")) {
            hexString = hexString.trim();
            hexString = hexString.toUpperCase();
            int length = hexString.length() / 2;
            char[] hexChars = hexString.toCharArray();
            byte[] d = new byte[length];

            for(int i = 0; i < length; ++i) {
                int pos = i * 2;
                d[i] = (byte)(charToByte(hexChars[pos]) << 4 | charToByte(hexChars[pos + 1]));
            }

            return d;
        } else {
            return null;
        }
    }

    public static byte charToByte(char c) {
        return (byte)"0123456789ABCDEF".indexOf(c);
    }

    public static String extractData(byte[] data, int position) {
        return formatHexString(new byte[]{data[position]});
    }
}
