package com.pureenee.repository;

import android.content.Context;

import com.pureenee.model.TipoProdotto;

import java.util.List;

public class TipoProdottoRepository extends BaseRepository{

    public TipoProdottoRepository(Context context) {
        super(context);
    }

    public void insertTipoProdotto(TipoProdotto tipoProdotto){
        dbManager.tipoProdottoDAO().insert(tipoProdotto);
    }

    public List<TipoProdotto> getAllTipoProdotti(){
        return dbManager.tipoProdottoDAO().getAll();
    }

    public TipoProdotto findTipoProdotto(long id){
        return dbManager.tipoProdottoDAO().getFromId(id);
    }

}
