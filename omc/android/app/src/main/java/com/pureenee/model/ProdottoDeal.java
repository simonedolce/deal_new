package com.pureenee.model;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import io.objectbox.annotation.Backlink;
import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToMany;
import io.objectbox.relation.ToOne;

@Entity
public class ProdottoDeal {

    @Id
    private long id;

    ToOne<Prodotto> prodotto;

    ToOne<Deal> deal;

    @Backlink(to = "prodottoDeal")
    ToMany<ProdottoOrdine> prodottiOrdine;

    private double quantitativoProdottoDeal;

    private double disponibilitaPersonale;

    private double disponibilitaMercato;

    private double quantitativoProdottoDealIniziale;

    private double disponibilitaMercatoIniziale;

    private double disponibilitaPersonaleIniziale;

    private double prezzoIngrosso;

    private double prezzoDettaglio;

    private double importoInvestito;

    private double importoRientrato;

    public ProdottoDeal(

    ) {
    }

    public Prodotto getProdotto(){
        return this.prodotto.getTarget();
    }

    public void setProdotto(Prodotto prodotto){
        this.prodotto.setTarget(prodotto);
    }

    public Deal getDeal(){
        return this.deal.getTarget();
    }

    public void setDeal(Deal deal){
        this.deal.setTarget(deal);
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getPrezzoIngrosso() {return prezzoIngrosso;}

    public void setPrezzoIngrosso(double prezzoIngrosso) {this.prezzoIngrosso = prezzoIngrosso;}

    public double getPrezzoDettaglio() {return prezzoDettaglio;}

    public void setPrezzoDettaglio(double prezzoDettaglio) {
        this.prezzoDettaglio = prezzoDettaglio;
    }

    public double getQuantitativoProdottoDeal() {
        return quantitativoProdottoDeal;
    }

    public void setQuantitativoProdottoDeal(double quantitativoProdottoDeal) {
        this.quantitativoProdottoDeal = quantitativoProdottoDeal;
    }

    public double getDisponibilitaPersonale() {
        return disponibilitaPersonale;
    }

    public void setDisponibilitaPersonale(double disponibilitaPersonale) {
        this.disponibilitaPersonale = disponibilitaPersonale;
    }

    public double getDisponibilitaMercato() {
        return disponibilitaMercato;
    }

    public void setDisponibilitaMercato(double disponibilitaMercato) {
        this.disponibilitaMercato = disponibilitaMercato;
    }

    public double getQuantitativoProdottoDealIniziale() {
        return quantitativoProdottoDealIniziale;
    }

    public void setQuantitativoProdottoDealIniziale(double quantitativoProdottoDealIniziale) {
        this.quantitativoProdottoDealIniziale = quantitativoProdottoDealIniziale;
    }

    public double getDisponibilitaMercatoIniziale() {
        return disponibilitaMercatoIniziale;
    }

    public void setDisponibilitaMercatoIniziale(double disponibilitaMercatoIniziale) {
        this.disponibilitaMercatoIniziale = disponibilitaMercatoIniziale;
    }

    public double getDisponibilitaPersonaleIniziale() {
        return disponibilitaPersonaleIniziale;
    }

    public void setDisponibilitaPersonaleIniziale(double disponibilitaPersonaleIniziale) {
        this.disponibilitaPersonaleIniziale = disponibilitaPersonaleIniziale;
    }

    public double getImportoInvestito() {
        return importoInvestito;
    }

    public void setImportoInvestito(double importoInvestito) {
        this.importoInvestito = importoInvestito;
    }

    public double getImportoRientrato() {
        return importoRientrato;
    }

    public void setImportoRientrato(double importoRientrato) {
        this.importoRientrato = importoRientrato;
    }

    public List<ProdottoOrdine> getProdottiOrdine(){
        return this.prodottiOrdine;
    }

}


//
    //private double prezzoIngrosso;
//
    //private double prezzoDettaglio;
//
    //private double importoInvestito;
//
    //private double importoRientrato;