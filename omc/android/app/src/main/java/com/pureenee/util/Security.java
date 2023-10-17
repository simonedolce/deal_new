package com.pureenee.util;

import com.pureenee.repository.UserRepository;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public class Security {

    public String encrypt(String plainText) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, BadPaddingException, InvalidKeyException {
        EncryptionResolver encryptionResolver = new EncryptionResolver();
        encryptionResolver.setPlainText(plainText);
        return encryptionResolver.encrypt();
    }

    public String decrypt(String encodedText) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, BadPaddingException, InvalidKeyException {
        EncryptionResolver encryptionResolver = new EncryptionResolver();
        encryptionResolver.setCodeText(encodedText);
        return encryptionResolver.decrypt();
    }
}
