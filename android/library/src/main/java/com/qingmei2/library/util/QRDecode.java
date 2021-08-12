package com.qingmei2.library.util;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.BinaryBitmap;
import com.google.zxing.ChecksumException;
import com.google.zxing.DecodeHintType;
import com.google.zxing.FormatException;
import com.google.zxing.NotFoundException;
import com.google.zxing.RGBLuminanceSource;
import com.google.zxing.Result;
import com.google.zxing.common.GlobalHistogramBinarizer;
import com.google.zxing.qrcode.QRCodeReader;

import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.EnumMap;
import java.util.List;
import java.util.Map;

/**
 * Created by hupei on 2016/7/7.
 */
public final class QRDecode {

    public static final Map<DecodeHintType, Object> HINTS = new EnumMap<>(DecodeHintType.class);

    static {
        List<BarcodeFormat> formats = new ArrayList<BarcodeFormat>();
        formats.add(BarcodeFormat.QR_CODE);
        HINTS.put(DecodeHintType.POSSIBLE_FORMATS, formats);
        HINTS.put(DecodeHintType.CHARACTER_SET, "utf-8");
    }

    private QRDecode() {
    }

    /**
     * 解析二维码图片
     *
     * @param picturePath
     * @return
     */
    public static String decodeQR(String picturePath) {
        try {
            return decodeQR(loadBitmap(picturePath));
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        return "";
    }

    /**
     * 解析二维码图片
     *
     * @param srcBitmap
     * @return
     */
    public static String decodeQR(Bitmap srcBitmap) {
        Result result = null;
        if (srcBitmap != null) {
            int width = srcBitmap.getWidth();
            int height = srcBitmap.getHeight();
            int[] pixels = new int[width * height];
            srcBitmap.getPixels(pixels, 0, width, 0, 0, width, height);
            //新建一个RGBLuminanceSource对象
            RGBLuminanceSource source = new RGBLuminanceSource(width, height, pixels);
            //将图片转换成二进制图片
            BinaryBitmap binaryBitmap = new BinaryBitmap(new GlobalHistogramBinarizer(source));
            QRCodeReader reader = new QRCodeReader();//初始化解析对象
            try {
                result = reader.decode(binaryBitmap, HINTS);//开始解析
                return result.getText();
            } catch (NotFoundException e) {
                e.printStackTrace();
            } catch (ChecksumException e) {
                e.printStackTrace();
            } catch (FormatException e) {
                e.printStackTrace();
            }
        }

        return "";
    }

    private static Bitmap loadBitmap(String picturePath) throws FileNotFoundException {
        BitmapFactory.Options opt = new BitmapFactory.Options();
        opt.inJustDecodeBounds = true;
        Bitmap bitmap = BitmapFactory.decodeFile(picturePath, opt);
        // 获取到这个图片的原始宽度和高度
        int picWidth = opt.outWidth;
        int picHeight = opt.outHeight;
        // 获取画布中间方框的宽度和高度
        int screenWidth = 280;
        int screenHeight = 280;
        // isSampleSize是表示对图片的缩放程度，比如值为2图片的宽度和高度都变为以前的1/2
        opt.inSampleSize = 1;
        // 根据屏的大小和图片大小计算出缩放比例
        if (picWidth > picHeight) {
            if (picWidth > screenWidth)
                opt.inSampleSize = picWidth / screenWidth;
        } else {
            if (picHeight > screenHeight)
                opt.inSampleSize = picHeight / screenHeight;
        }
        // 生成有像素经过缩放了的bitmap
        opt.inJustDecodeBounds = false;
        bitmap = BitmapFactory.decodeFile(picturePath, opt);
        if (bitmap == null) {
            throw new FileNotFoundException("Couldn't open " + picturePath);
        }
        return bitmap;
    }
}