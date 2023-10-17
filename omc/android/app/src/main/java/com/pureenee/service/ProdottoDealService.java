package com.pureenee.service;

import com.pureenee.box.ObjectBox;
import com.pureenee.model.Deal;
import com.pureenee.model.Debt;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.objects.ProdottoDealBean;

import java.util.ArrayList;
import java.util.List;

import io.objectbox.Box;

public class ProdottoDealService {
    Box<ProdottoDeal> prodottoDealBox;


    public ProdottoDealService() {
        this.prodottoDealBox = ObjectBox.get().boxFor(ProdottoDeal.class);
    }

    public void insertProdottoDeal(ProdottoDeal prodottoDeal){
        this.prodottoDealBox.put(prodottoDeal);
    }

    public List<ProdottoDeal> getProdottiFromDeal(Deal deal){
        return new ArrayList<>();
       // return getFromDeal(deal.getId());
    }

    public List<String> getProdottiDealStringify(Deal deal){
        List<ProdottoDeal> prodottiDeals = getProdottiFromDeal(deal);
        for (ProdottoDeal prodottoDeal:prodottiDeals) {

            ProdottoDealBean bean = new ProdottoDealBean();

            bean.setDisponibilitaPersonale(prodottoDeal.getDisponibilitaPersonale());
            bean.setDisponibilitaMercato(prodottoDeal.getDisponibilitaMercato());
            bean.setDisponibilitaPersonale(prodottoDeal.getDisponibilitaPersonale());
            bean.setDisponibilitaPersonaleIniziale(prodottoDeal.getDisponibilitaPersonaleIniziale());
            bean.setImportoInvestito(prodottoDeal.getImportoInvestito());
            bean.setImportoRientrato(prodottoDeal.getImportoRientrato());
            bean.setPrezzoDettaglio(prodottoDeal.getPrezzoDettaglio());
            bean.setPrezzoIngrosso(prodottoDeal.getPrezzoIngrosso());

        }
        return new ArrayList<>();
    }

}
