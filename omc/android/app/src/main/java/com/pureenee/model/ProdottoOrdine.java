package com.pureenee.model;

import io.objectbox.annotation.Backlink;
import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToOne;

@Entity
public class ProdottoOrdine {

    @Id
    private long id;


    ToOne<ProdottoDeal> prodottoDeal;

    ToOne<Ordine> ordine;

    private double quantitativoEffettivo;

    private double quantitativoPrevisto;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getQuantitativoEffettivo() {
        return quantitativoEffettivo;
    }

    public void setQuantitativoEffettivo(double quantitativoEffettivo) {
        this.quantitativoEffettivo = quantitativoEffettivo;
    }

    public double getQuantitativoPrevisto() {
        return quantitativoPrevisto;
    }

    public void setQuantitativoPrevisto(double quantitativoPrevisto) {
        this.quantitativoPrevisto = quantitativoPrevisto;
    }

    public double getCresta() {
        return this.quantitativoPrevisto - this.quantitativoEffettivo;
    }

    public void setProdottoDeal(ProdottoDeal prodottoDeal){
        this.prodottoDeal.setTarget(prodottoDeal);
    }

    public Ordine getOrdine(){
        return this.ordine.getTarget();
    }

    public void setOrdine(Ordine ordine){
        this.ordine.setTarget(ordine);
    }

    public ProdottoDeal getProdottoDeal(){
        return this.prodottoDeal.getTarget();
    }

}
