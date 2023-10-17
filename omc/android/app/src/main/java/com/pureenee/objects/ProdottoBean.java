package com.pureenee.objects;


import com.pureenee.model.TipoProdotto;

import org.json.JSONException;
import org.json.JSONObject;

public class ProdottoBean {
    private long id;

    private String nomeProdotto;

    private TipoProdottoBean tipoProdotto;

    public ProdottoBean() {
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getNomeProdotto() {
        return nomeProdotto;
    }

    public void setNomeProdotto(String nomeProdotto) {
        this.nomeProdotto = nomeProdotto;
    }

    public TipoProdottoBean getTipoProdotto() {
        return tipoProdotto;
    }

    public void setTipoProdotto(TipoProdottoBean tipoProdotto) {
        this.tipoProdotto = tipoProdotto;
    }

    ProdottoBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getLong("id");
        this.nomeProdotto = jsonObject.getString("nomeProdotto");
        this.tipoProdotto = new TipoProdottoBean().fromJson(jsonObject.getJSONObject("tipoProdotto"));
        return this;
    }
}
