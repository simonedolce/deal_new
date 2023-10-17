package com.pureenee.objects;

import org.json.JSONException;
import org.json.JSONObject;


public class SanamentoDebitoBean {
    long id;

    double importoSanamento;

    long dataSanamento;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getImportoSanamento() {
        return importoSanamento;
    }

    public void setImportoSanamento(double importoSanamento) {
        this.importoSanamento = importoSanamento;
    }
    public long getDataSanamento() {
        return dataSanamento;
    }

    public void setDataSanamento(long dataSanamento) {
        this.dataSanamento = dataSanamento;
    }


    public SanamentoDebitoBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getLong("id");
        this.importoSanamento = jsonObject.getDouble("importoSanamento");
        this.dataSanamento = jsonObject.getLong("dataSanamento");
        return this;
    }

}
