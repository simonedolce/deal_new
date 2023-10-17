package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;


import com.pureenee.model.ProdottoOrdine;

import java.util.List;

@Dao
public interface ProdottoOrdineDAO {
    @Insert
    long insert(ProdottoOrdine prodottoOrdine);

    @Query("SELECT * FROM ProdottoOrdine WHERE id = :id")
    ProdottoOrdine getFromId(long id);

    @Delete
    void delete(ProdottoOrdine prodottoOrdine);

    @Query("SELECT * FROM ProdottoOrdine")
    List<ProdottoOrdine> getAll();
}
