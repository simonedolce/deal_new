package com.pureenee.model;


import java.util.List;

import io.objectbox.annotation.Backlink;
import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToMany;
import io.objectbox.relation.ToOne;

@Entity
public class Ordine {

    @Id
    private long id;

    ToOne<Customer> customer;

    @Backlink(to = "ordine")
    ToMany<ProdottoOrdine> prodottiOrdine;

    ToOne<Debt> debito;

    long dataOrdine;

    double totale;

    double totalePagato;

    public Ordine() {
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }

    public double getTotalePagato() {
        return totalePagato;
    }

    public void setTotalePagato(double totalePagato) {
        this.totalePagato = totalePagato;
    }

    public double getTotale() {
        return totale;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public long getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(long dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public void addProdottoOrdine(ProdottoOrdine prodottoOrdine){
        this.prodottiOrdine.add(prodottoOrdine);
    }

    public void setDebito(Debt debito){
        this.debito.setTarget(debito);
    }

    // Se ha avuto debito
    public boolean hasGotDebito() {
        return this.debito.getTarget() != null;
    }

    // Se al momento ha debiti in corso
    public boolean hasDebito() {
        if(this.debito.getTarget() != null){
            return this.debito.getTarget().isAttivo();
        }
        return false;
    }

    public Debt getDebito(){
        return this.debito.getTarget();
    }

    public void setCustomer(Customer customer){
        this.customer.setTarget(customer);
    }

    public List<ProdottoOrdine> getProdottiOrdine(){
        return this.prodottiOrdine;
    }

}
