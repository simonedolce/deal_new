package com.pureenee.repository;

import android.content.Context;

import com.pureenee.model.User;
import com.pureenee.util.DbManager;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;

public class UserRepository extends BaseRepository {

    public UserRepository(Context context) {
        super(context);
    }

    public boolean isUserActive(){
        boolean flag = false;
        int count = this.dbManager.userDao().countUser();
        if(count > 0) flag = true;
        return flag;
    }

    public boolean insertUser(String password) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, BadPaddingException, InvalidKeyException {
        User user = new User();
        user.setPassword(password);

        try {
            this.dbManager.userDao().insert(user);
        } catch (Exception e) {
            return false;
        }

        return true;
    }

}
