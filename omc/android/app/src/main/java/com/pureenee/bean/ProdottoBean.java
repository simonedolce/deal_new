package com.pureenee.bean;

import com.pureenee.model.Prodotto;
import com.pureenee.model.TipoProdotto;

public class ProdottoBean {
    private long id;

    private String nomeProdotto;

    private TipoProdottoBean tipoProdotto;

    public ProdottoBean() {

    }

    public ProdottoBean setData(Prodotto prodotto){
        this.id = prodotto.getId();
        this.nomeProdotto = prodotto.getNomeProdotto();
        this.tipoProdotto = new TipoProdottoBean().setData(prodotto.getTipoProdotto());
        return this;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNomeProdotto() {
        return nomeProdotto;
    }

    public void setNomeProdotto(String nomeProdotto) {
        this.nomeProdotto = nomeProdotto;
    }

    public TipoProdottoBean getTipoProdottoBean() {
        return tipoProdotto;
    }

    public void setTipoProdottoBean(TipoProdottoBean tipoProdottoBean) {
        this.tipoProdotto = tipoProdottoBean;
    }
}
