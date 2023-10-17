package com.pureenee.objects;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;

public class DebtBean {
    long id;

    double importoDebito;

    boolean isAttivo;

    List<SanamentoDebitoBean> sanamenti = new ArrayList<>();

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getImportoDebito() {
        return importoDebito;
    }

    public void setImportoDebito(double importoDebito) {
        this.importoDebito = importoDebito;
    }

    public boolean isAttivo() {
        return isAttivo;
    }

    public void setIsAttivo(boolean isAttivo) {
        this.isAttivo = isAttivo;
    }

    public List<SanamentoDebitoBean> getSanamenti() {
        return sanamenti;
    }

    public void setSanamentoBeans(List<SanamentoDebitoBean> sanamentoBeans) {
        this.sanamenti = sanamentoBeans;
    }

    public DebtBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getInt("id");
        this.importoDebito = jsonObject.getDouble("importoDebito");
        this.isAttivo = jsonObject.getBoolean("isAttivo");
        JSONArray sanamentiDebito = jsonObject.getJSONArray("sanamenti");

        for (int i = 0; i < sanamentiDebito.length(); i++) {
            this.sanamenti.add(new SanamentoDebitoBean().fromJson(sanamentiDebito.getJSONObject(i)));
        }


        return this;
    }

}
