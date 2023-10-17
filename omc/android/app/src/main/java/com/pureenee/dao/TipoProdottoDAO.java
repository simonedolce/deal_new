package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;


import com.pureenee.model.TipoProdotto;

import java.util.List;
@Dao
public interface TipoProdottoDAO {
    @Insert
    long insert(TipoProdotto tipoProdotto);

    @Query("SELECT * FROM TipoProdotto WHERE id = :id")
    TipoProdotto getFromId(long id);

    @Delete
    void delete(TipoProdotto tipoProdotto);

    @Query("SELECT * FROM TipoProdotto")
    List<TipoProdotto> getAll();
}
