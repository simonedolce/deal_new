package com.pureenee.service;

import android.content.Context;

import com.pureenee.box.ObjectBox;
import com.pureenee.model.TipoProdotto;
import com.pureenee.repository.TipoProdottoRepository;

import java.util.List;

import io.objectbox.Box;

public class TipoProdottoService {
    Box<TipoProdotto> tipoProdottoBox;
    public TipoProdottoService() {
        this.tipoProdottoBox = ObjectBox.get().boxFor(TipoProdotto.class);
    }

    public void initTipoProdotto(){
        String[] strArray = new String[] {"Marijuana","Hashish","Cocaine","Lsd"};
        for (int i = 0; i < strArray.length; i++) {
            TipoProdotto tipoProdotto = new TipoProdotto();
            tipoProdotto.setDescrizione(strArray[i]);
            tipoProdottoBox.put(tipoProdotto);
        }
    }

    public TipoProdotto find(int id){
        return tipoProdottoBox.get(id);
    }

    public List<TipoProdotto> getAll(){
        return this.tipoProdottoBox.getAll();
    }



}
