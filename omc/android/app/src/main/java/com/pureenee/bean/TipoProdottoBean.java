package com.pureenee.bean;

import com.pureenee.model.TipoProdotto;

public class TipoProdottoBean {

    private long id;

    private String descrizione;

    public TipoProdottoBean() {

    }

    public TipoProdottoBean setData(TipoProdotto tipoProdotto){
        this.id = tipoProdotto.getId();
        this.descrizione = tipoProdotto.getDescrizione();
        return this;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }
}
