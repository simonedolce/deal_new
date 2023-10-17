package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import com.pureenee.model.Debt;

import java.util.List;

@Dao
public interface DebtDAO {

    @Insert
    long insert(Debt debt);

    @Query("SELECT * FROM Debt WHERE id = :id")
    Debt getFromId(long id);

    @Delete
    void delete(Debt debt);

    @Query("SELECT * FROM Debt")
    List<Debt> getAll();
}
