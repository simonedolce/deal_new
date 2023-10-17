package com.pureenee.objects;

import com.google.gson.Gson;
import com.pureenee.model.Ordine;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class CustomerBean {

    private long id;

    private String nome;

    private List<OrdineBean> ordini = new ArrayList<>();

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

    public List<OrdineBean> getOrdini() {
        return ordini;
    }

    public void setOrdini(List<OrdineBean> ordini) {
        this.ordini = ordini;
    }


    public CustomerBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getLong("id");
        this.nome = jsonObject.getString("nome");
        JSONArray ordiniJson = jsonObject.getJSONArray("ordini");

        for (int i = 0; i < ordiniJson.length(); i++) {
            this.ordini.add(new OrdineBean().fromJson(ordiniJson.getJSONObject(i)));
        }


        return this;
    }



}
