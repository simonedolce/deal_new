package com.pureenee.model;


import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToOne;

@Entity
public class Prodotto {

    @Id
    private long id;

    private String nomeProdotto;

    ToOne<TipoProdotto> tipoProdotto;

    public void setTipoProdotto(TipoProdotto tipoProdotto){
        this.tipoProdotto.setTarget(tipoProdotto);
    }

    public TipoProdotto getTipoProdotto(){
        return this.tipoProdotto.getTarget();
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
}
