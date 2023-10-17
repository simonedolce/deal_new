package com.pureenee.bean;

import com.pureenee.model.Deal;
import com.pureenee.model.ProdottoDeal;


public class ProdottoDealBean {

    private long id;

    private ProdottoBean prodotto;

    private DealBean deal;

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


    public ProdottoDealBean() {

    }

    public ProdottoDealBean setData(ProdottoDeal prodottoDeal){
        this.id = prodottoDeal.getId();
        this.prodotto = new ProdottoBean().setData(prodottoDeal.getProdotto());
        this.quantitativoProdottoDeal = prodottoDeal.getQuantitativoProdottoDeal();
        this.disponibilitaPersonale = prodottoDeal.getDisponibilitaPersonale();
        this.disponibilitaMercato = prodottoDeal.getDisponibilitaMercato();
        this.quantitativoProdottoDealIniziale = prodottoDeal.getQuantitativoProdottoDealIniziale();
        this.disponibilitaMercatoIniziale = prodottoDeal.getDisponibilitaMercatoIniziale();
        this.disponibilitaPersonaleIniziale = prodottoDeal.getDisponibilitaPersonaleIniziale();
        this.prezzoIngrosso = prodottoDeal.getPrezzoIngrosso();
        this.prezzoDettaglio = prodottoDeal.getPrezzoDettaglio();
        this.importoInvestito = prodottoDeal.getImportoInvestito();
        this.importoRientrato = prodottoDeal.getImportoRientrato();
        return this;
    }



    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public ProdottoBean getProdotto() {
        return prodotto;
    }

    public void setProdotto(ProdottoBean prodotto) {
        this.prodotto = prodotto;
    }

    public DealBean getDeal() {
        return deal;
    }

    public void setDeal(DealBean dealBean) {
        this.deal = dealBean;
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

    public double getPrezzoIngrosso() {
        return prezzoIngrosso;
    }

    public void setPrezzoIngrosso(double prezzoIngrosso) {
        this.prezzoIngrosso = prezzoIngrosso;
    }

    public double getPrezzoDettaglio() {
        return prezzoDettaglio;
    }

    public void setPrezzoDettaglio(double prezzoDettaglio) {
        this.prezzoDettaglio = prezzoDettaglio;
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
}
