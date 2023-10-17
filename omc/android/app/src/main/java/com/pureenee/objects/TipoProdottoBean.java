package com.pureenee.objects;

import org.json.JSONException;
import org.json.JSONObject;

public class TipoProdottoBean {
    long id;
    String descrizione;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }


    public TipoProdottoBean fromJson(JSONObject jsonObject) throws JSONException {
        this.id = jsonObject.getLong("id");
        this.descrizione = jsonObject.getString("descrizione");
        return this;
    }
}
