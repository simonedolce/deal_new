package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import com.pureenee.model.Deal;

import java.util.List;

@Dao
public interface DealDao {
    @Insert
    long insert(Deal deal);

    @Query("SELECT * FROM Deal WHERE id = :id")
    Deal getFromId(long id);

    @Delete
    void delete(Deal deal);

    @Query("SELECT * FROM Deal")
    List<Deal> getAll();
}
