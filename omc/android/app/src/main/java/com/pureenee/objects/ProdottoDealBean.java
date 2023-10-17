package com.pureenee.objects;

import com.pureenee.model.ProdottoDeal;

import org.json.JSONException;
import org.json.JSONObject;

public class ProdottoDealBean {

    long id;

    ProdottoBean prodotto;

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

    public double getQuantitativoProdottoDeal() {
        return quantitativoProdottoDeal;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
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

    public ProdottoBean getProdottoBean() {
        return prodotto;
    }

    public void setProdottoBean(ProdottoBean prodottoBean) {
        this.prodotto = prodottoBean;
    }

    public ProdottoDealBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getLong("id");
        this.quantitativoProdottoDeal = jsonObject.getDouble("quantitativoProdottoDeal");
        this.disponibilitaPersonale = jsonObject.getDouble("disponibilitaPersonale");
        this.disponibilitaMercato = jsonObject.getDouble("disponibilitaMercato");
        this.quantitativoProdottoDealIniziale = jsonObject.getDouble("quantitativoProdottoDealIniziale");
        this.disponibilitaMercatoIniziale = jsonObject.getDouble("disponibilitaMercatoIniziale");
        this.disponibilitaPersonaleIniziale = jsonObject.getDouble("disponibilitaPersonaleIniziale");
        this.prezzoIngrosso = jsonObject.getDouble("prezzoIngrosso");
        this.prezzoDettaglio = jsonObject.getDouble("prezzoDettaglio");
        this.importoInvestito = jsonObject.getDouble("importoInvestito");
        this.importoRientrato = jsonObject.getDouble("importoRientrato");
        this.prodotto = new ProdottoBean();

        return this;
    }

}
