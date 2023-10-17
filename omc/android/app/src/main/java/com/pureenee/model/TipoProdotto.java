package com.pureenee.model;

import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;

@Entity
public class TipoProdotto {

    @Id
    private long id;

    private String descrizione;

    public TipoProdotto() {
    }

    public long getId() {return id;}

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
