package com.pureenee.model;


import java.util.List;

import io.objectbox.annotation.Backlink;
import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToMany;

@Entity
public class Customer {

    @Id
    private long id;

    private String nome;

    @Backlink(to = "customer")
    ToMany<Ordine> ordini;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public List<Ordine> getOrdini(){
        return this.ordini;
    }

}
