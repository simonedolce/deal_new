package com.pureenee.objects;

import com.google.gson.JsonObject;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;

public class ProdottoOrdineBean {
    private long id;
    private ProdottoDealBean prodottoDeal;
    private double quantitativoEffettivo;
    private double quantitativoPrevisto;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public ProdottoDealBean getProdottoDeal() {
        return prodottoDeal;
    }

    public void setProdottoDeal(ProdottoDealBean prodottoDeal) {
        this.prodottoDeal = prodottoDeal;
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

    public ProdottoOrdineBean fromJson(JSONObject object) throws JSONException {
        this.quantitativoEffettivo = object.getDouble("quantitativoEffettivo");
        this.quantitativoPrevisto = object.getDouble("quantitativoPrevisto");
        this.prodottoDeal = new ProdottoDealBean().fromJson(object.getJSONObject("prodottoDeal"));
        return this;
    }
}
