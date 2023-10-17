package com.pureenee.repository;

import android.content.Context;

import com.pureenee.model.Prodotto;

public class ProdottoRepository extends BaseRepository{
    public ProdottoRepository(Context context) {
        super(context);
    }

    public void addProdotto(Prodotto prodotto){
        dbManager.prodottoDAO().insert(prodotto);
    }

    public Prodotto get(long idProdotto){
        return dbManager.prodottoDAO().getFromId(idProdotto);
    }


}
