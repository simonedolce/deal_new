package com.pureenee.model;


import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import io.objectbox.annotation.Backlink;
import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToMany;

@Entity
public class Deal {

    @Id
    private long id;

    private Date dataDeal;

    @Backlink(to = "deal")
    ToMany<ProdottoDeal> prodottiDeals;

    public List<ProdottoDeal> getProdottiDeals(){
        return this.prodottiDeals;
    }

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Date getDataDeal() {
        return dataDeal;
    }

    public void setDataDeal(Date dataDeal) {
        this.dataDeal = dataDeal;
    }

    public void addProdottoDeal(ProdottoDeal prodottoDeal){
        this.prodottiDeals.add(prodottoDeal);
    }

    public List<Debt> getDebiti(){
        List<Debt> debiti = new ArrayList<>();
        for (ProdottoDeal pDeal:this.prodottiDeals) {
            for (ProdottoOrdine pOrdine:pDeal.getProdottiOrdine()) {
                if(pOrdine.getOrdine().hasDebito()){
                    debiti.add(pOrdine.getOrdine().getDebito());
                }
            }
        }
        return debiti;
    }
}
