package com.pureenee.objects;

import com.pureenee.model.Debt;
import com.pureenee.model.ProdottoOrdine;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


public class OrdineBean {

    private long id;

    List<ProdottoOrdineBean> prodottiOrdine = new ArrayList<>();

    DebtBean debito;

    CustomerBean customerBean;

    private long dataOrdine;

    private double totale;

    private double totalePagato;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public List<ProdottoOrdineBean> getProdottiOrdine() {
        return prodottiOrdine;
    }

    public void setProdottiOrdine(List<ProdottoOrdineBean> prodottiOrdine) {
        this.prodottiOrdine = prodottiOrdine;
    }

    public long getDataOrdine() {
        return dataOrdine;
    }

    public void setDataOrdine(long dataOrdine) {
        this.dataOrdine = dataOrdine;
    }

    public double getTotale() {
        return totale;
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

    public CustomerBean getCustomerBean() {
        return customerBean;
    }

    public void setCustomerBean(CustomerBean customerBean) {
        this.customerBean = customerBean;
    }

    public void addProdottoOrdine(ProdottoOrdineBean prodottoOrdine){
        this.prodottiOrdine.add(prodottoOrdine);
    }

    public DebtBean getDebito() {
        return debito;
    }

    public void setDebito(DebtBean debito) {
        this.debito = debito;
    }

    public OrdineBean fromJson(JSONObject jsonObject) throws JSONException {
        this.prodottiOrdine = new ArrayList<>();
        this.totale = jsonObject.getDouble("totale");
        this.totalePagato = jsonObject.getDouble("totalePagato");
        this.dataOrdine = jsonObject.getLong("dataOrdine");
        JSONArray prodottiOrdine = jsonObject.getJSONArray("prodottiOrdine");


        if(!jsonObject.isNull("debito")){
            this.debito = new DebtBean().fromJson(jsonObject.getJSONObject("debito"));
        }

        for (int i = 0; i < prodottiOrdine.length(); i++) {
            ProdottoOrdineBean pOBean = new ProdottoOrdineBean().fromJson(prodottiOrdine.getJSONObject(i));
            this.prodottiOrdine.add(pOBean);
        }

        if(!jsonObject.isNull("customer")){
            this.customerBean = new CustomerBean().fromJson(jsonObject.getJSONObject("customer"));
        }


        return this;

    }
}
