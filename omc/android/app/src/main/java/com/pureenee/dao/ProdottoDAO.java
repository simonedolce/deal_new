package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import com.pureenee.model.Prodotto;

import java.util.List;

@Dao
public interface ProdottoDAO {
    @Insert
    long insert(Prodotto prodotto);

    @Query("SELECT * FROM Prodotto WHERE id = :id")
    Prodotto getFromId(long id);

    @Delete
    void delete(Prodotto prodotto);

    @Query("SELECT * FROM Prodotto")
    List<Prodotto> getAll();
}

