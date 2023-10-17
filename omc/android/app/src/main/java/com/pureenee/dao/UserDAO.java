package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import com.pureenee.model.User;

import java.util.List;

@Dao
public interface UserDAO {
    @Insert
    long insert(User user);

    @Query("SELECT * FROM User WHERE password = :password")
    User getFromPassword(String password);

    @Query("SELECT COUNT(password) FROM User")
    int countUser();

    @Delete
    void delete(User user);

    @Query("SELECT * FROM User")
    List<User> getAll();
}
