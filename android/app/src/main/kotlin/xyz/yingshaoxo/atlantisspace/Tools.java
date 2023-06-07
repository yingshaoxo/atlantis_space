package xyz.yingshaoxo.atlantisspace;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.util.Base64;

import org.jetbrains.annotations.NotNull;

import java.io.ByteArrayOutputStream;

public class Tools {
    @NotNull
    public static String convert_drawable_to_base64(@NotNull Drawable an_image) {
        final Bitmap bitmap = Bitmap.createBitmap(an_image.getIntrinsicWidth(), an_image.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        final Canvas canvas = new Canvas(bitmap);
        an_image.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        an_image.draw(canvas);

        ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.JPEG, 100, byteStream);
        byte[] byteArray = byteStream.toByteArray();
        String baseString = Base64.encodeToString(byteArray,Base64.DEFAULT);
        return baseString;
    }
}
