package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import com.pureenee.model.Ordine;

import java.util.List;

@Dao
public interface OrdineDAO {

    @Insert
    long insert(Ordine ordine);

    @Query("SELECT * FROM Ordine WHERE id = :id")
    Ordine getFromId(long id);

    @Delete
    void delete(Ordine ordine);

    @Query("SELECT * FROM Ordine")
    List<Ordine> getAll();
}
