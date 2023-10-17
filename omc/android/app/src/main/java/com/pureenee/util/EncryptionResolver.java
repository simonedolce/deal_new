package com.pureenee.util;
import android.os.Build;

import javax.crypto.BadPaddingException;
import javax.crypto.Cipher;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class EncryptionResolver {

    private static final String SKEY = "62S8D59SP_!rT%63oK";
    private String plainText;
    private String codeText;

    public String decrypt() throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        String decryptedText = "";
        SecretKeySpec secretKeySpec = createSpecKey();

        Cipher cipher = initCipher(Cipher.DECRYPT_MODE , secretKeySpec);
        byte[] decryptBase64 = decryptBase64(this.codeText);

        byte[] decryptedBytes = cipher.doFinal(decryptBase64);

        // Conversione dei dati decifrati in una stringa
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            decryptedText = new String(decryptedBytes, StandardCharsets.UTF_8);
        }

        return decryptedText;


    }

    public String encrypt() throws NoSuchPaddingException, NoSuchAlgorithmException, InvalidKeyException, IllegalBlockSizeException, BadPaddingException {
        // Creo l'oggetto dalla stringa della chiave
        SecretKeySpec secretKeySpec = createSpecKey();

        // Inizializzo la codifica
        Cipher cipher = initCipher(Cipher.ENCRYPT_MODE, secretKeySpec);

        // Codifico in blowfish
        byte[] encryptedBytes = new byte[0];
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT) {
            encryptedBytes = cipher.doFinal(this.plainText.getBytes(StandardCharsets.UTF_8));
        }

        // Codifico in base64
        return encryptBase64(encryptedBytes);

    }

    private SecretKeySpec createSpecKey(){
        byte[] keyBytes = new byte[0];

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            keyBytes = SKEY.getBytes(StandardCharsets.UTF_8);
        }

        return new SecretKeySpec(keyBytes, "Blowfish");
    }

    private byte[] decryptBase64(String encryptedText){
        byte[] decryptedText = null;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            decryptedText = Base64.getDecoder().decode(encryptedText);
        }
        return decryptedText;

    }

    private String encryptBase64(byte[] encryptedBytes){
        String encryptedText = null;
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
            encryptedText = Base64.getEncoder().encodeToString(encryptedBytes);
        }
        return encryptedText;
    }

    private Cipher initCipher(int mode, SecretKeySpec secretKeySpec) throws InvalidKeyException, NoSuchPaddingException, NoSuchAlgorithmException {
        Cipher cipher = Cipher.getInstance("Blowfish");
        if(mode == Cipher.ENCRYPT_MODE) cipher.init(Cipher.ENCRYPT_MODE, secretKeySpec);
        if(mode == Cipher.DECRYPT_MODE) cipher.init(Cipher.DECRYPT_MODE, secretKeySpec);
        return cipher;
    }

    public String getPlainText() {
        return plainText;
    }

    public void setPlainText(String plainText) {
        this.plainText = plainText;
    }

    public String getCodeText() {
        return codeText;
    }

    public void setCodeText(String codeText) {
        this.codeText = codeText;
    }
}
