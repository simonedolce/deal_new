package com.pureenee.service;

import android.content.Context;

import androidx.collection.ArrayMap;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.pureenee.bean.DealBean;
import com.pureenee.box.ObjectBox;
import com.pureenee.model.Deal;
import com.pureenee.model.Prodotto;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.objects.ElencoDeal;
import com.pureenee.repository.DealRepository;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import io.objectbox.Box;

public class DealService {
    Box<Deal> dealBox;
    Box<ProdottoOrdine> prodottoOrdineBox;

    ProdottoDealService prodottoDealService;
    Gson gson;

    public DealService() {
        this.dealBox = ObjectBox.get().boxFor(Deal.class);
        this.prodottoOrdineBox = ObjectBox.get().boxFor(ProdottoOrdine.class);
        this.prodottoDealService = new ProdottoDealService();
        gson = new Gson();
    }

    public double getImportoTotaleRientrato(List<ProdottoDeal> prodottoDealList){
        double importoTotaleRientrato = 0;
        for (ProdottoDeal prod:prodottoDealList) {
            importoTotaleRientrato += prod.getImportoRientrato();
        }
        return importoTotaleRientrato;
    }

    public double getDisponibilitaTotaleMercato(List<ProdottoDeal> prodottoDealList){
        double disponibilitaMercato = 0;
        for (ProdottoDeal prod:prodottoDealList) {
            disponibilitaMercato += prod.getDisponibilitaMercato();
        }
        return disponibilitaMercato;
    }

    public double getDisponibilaTotalePersonale(List<ProdottoDeal> prodottoDealList){
        double disponibilitaPersonale = 0;
        for (ProdottoDeal prod:prodottoDealList) {
            disponibilitaPersonale += prod.getDisponibilitaPersonale();
        }
        return disponibilitaPersonale;
    }

    public DealBean createDealData(Deal deal){
        DealBean bean = new DealBean();
        bean.setData(deal);
        return bean;
    }

    public List<String> getElencoDealDataStringify(){
        List<String> stringList = new ArrayList<>();
        for (Deal deal: dealBox.getAll()) {
            DealBean bean = new DealBean().setData(deal);
            stringList.add(gson.toJson(bean));
        }
        return stringList;
    }

    public Deal insertDeal(Deal deal){
        long idNew = dealBox.put(deal);
        return dealBox.get(idNew);
    }

    public void createNewDeal(JSONObject dealJson) throws JSONException {
        Box<ProdottoDeal> prodottoDealBox = ObjectBox.get().boxFor(ProdottoDeal.class);
        Box<Prodotto> prodottoBox = ObjectBox.get().boxFor(Prodotto.class);
        Deal deal = new Deal();
        deal.setDataDeal(new Date());

        JSONArray prodottiDeal = dealJson.getJSONArray("prodottiDeals");

        for (int i = 0; i < prodottiDeal.length(); i++) {
            JSONObject prodottoDealJson = prodottiDeal.getJSONObject(i);
            ProdottoDeal prodottoDeal = new ProdottoDeal();
            prodottoDeal.setQuantitativoProdottoDeal(prodottoDealJson.getDouble("quantitativoProdottoDeal"));
            prodottoDeal.setDisponibilitaPersonale(prodottoDealJson.getDouble("disponibilitaPersonale"));
            prodottoDeal.setDisponibilitaMercato(prodottoDealJson.getDouble("disponibilitaMercato"));
            prodottoDeal.setQuantitativoProdottoDealIniziale(prodottoDealJson.getDouble("quantitativoProdottoDealIniziale"));
            prodottoDeal.setDisponibilitaMercatoIniziale(prodottoDealJson.getDouble("disponibilitaMercatoIniziale"));
            prodottoDeal.setDisponibilitaPersonaleIniziale(prodottoDealJson.getDouble("disponibilitaPersonaleIniziale"));
            prodottoDeal.setPrezzoIngrosso(prodottoDealJson.getDouble("prezzoIngrosso"));
            prodottoDeal.setPrezzoDettaglio(prodottoDealJson.getDouble("prezzoDettaglio"));
            prodottoDeal.setImportoInvestito(prodottoDealJson.getDouble("importoInvestito"));
            prodottoDeal.setImportoRientrato(prodottoDealJson.getDouble("importoRientrato"));
            JSONObject prodottoJson = prodottoDealJson.getJSONObject("prodotto");
            Prodotto prodotto = prodottoBox.get(Long.parseLong(prodottoJson.getString("id")));
            prodottoDeal.setProdotto(prodotto);
            deal.addProdottoDeal(prodottoDeal);
        }

        insertDeal(deal);


    }



    public long count(){
        return this.dealBox.count();
    }

}
