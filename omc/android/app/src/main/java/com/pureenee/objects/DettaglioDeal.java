package com.pureenee.objects;

import com.pureenee.model.Deal;
import com.pureenee.model.ProdottoDeal;

import java.util.List;

public class DettaglioDeal extends Deal {
    private List<ProdottoDeal> prodottoDealList;

    public List<ProdottoDeal> getProdottoDealList() {
        return prodottoDealList;
    }

    public void setProdottoDealList(List<ProdottoDeal> prodottoDealList) {
        this.prodottoDealList = prodottoDealList;
    }
}
