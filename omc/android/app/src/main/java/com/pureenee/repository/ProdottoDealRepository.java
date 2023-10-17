package com.pureenee.repository;

import android.content.Context;

import com.pureenee.model.ProdottoDeal;

import java.util.List;

public class ProdottoDealRepository extends BaseRepository{
    public ProdottoDealRepository(Context context) {
        super(context);
    }

    public void insert(ProdottoDeal prodottoDeal){
        dbManager.prodottoDealDAO().insert(prodottoDeal);
    }

    public List<ProdottoDeal> getFromDeal(long id){
       return dbManager.prodottoDealDAO().getFromDeal(id);
    }
}
