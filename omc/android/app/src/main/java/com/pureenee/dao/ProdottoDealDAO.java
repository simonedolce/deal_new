package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;

import com.pureenee.model.ProdottoDeal;

import java.util.List;

@Dao
public interface ProdottoDealDAO {
    @Insert
    long insert(ProdottoDeal prodottoDeal);

    @Query("SELECT * FROM ProdottoDeal WHERE id = :id")
    ProdottoDeal getFromId(long id);

    @Query("SELECT * FROM ProdottoDeal WHERE id_deal = :id")
    List<ProdottoDeal> getFromDeal(long id);

    @Delete
    void delete(ProdottoDeal prodottoDeal);

    @Query("SELECT * FROM ProdottoDeal")
    List<ProdottoDeal> getAll();
}
