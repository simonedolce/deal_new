package com.pureenee.service;
import com.pureenee.box.ObjectBox;
import com.pureenee.model.User;

import java.util.List;

import io.objectbox.Box;

public class UserService {
    Box<User> userBox;

    public UserService() {
        this.userBox = ObjectBox.get().boxFor(User.class);
    }

    public void insertUser(String bFish){
        User user = new User();
        user.setPassword(bFish);
        this.userBox.put(user);
    }

    public boolean isUserActive(){
        List<User> userList = this.userBox.getAll();
        return userList.size() > 0;
    }

}
