package com.pureenee.service;

import android.content.Context;

import com.pureenee.box.ObjectBox;
import com.pureenee.model.Prodotto;
import com.pureenee.repository.ProdottoRepository;

import java.util.List;

import io.objectbox.Box;

public class ProdottoService{
    Box<Prodotto> prodottoBox;
    public ProdottoService() {
        this.prodottoBox = ObjectBox.get().boxFor(Prodotto.class);
    }

    public void inserisciProdotto(Prodotto prodotto){
        this.prodottoBox.put(prodotto);
    }

    public List<Prodotto> getAllProdotti(){
        return this.prodottoBox.getAll();
    }

}
