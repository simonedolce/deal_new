package com.pureenee.service;

import com.pureenee.box.ObjectBox;
import com.pureenee.enumeration.FlagDebito;
import com.pureenee.model.Customer;
import com.pureenee.model.Deal;
import com.pureenee.model.Debt;
import com.pureenee.model.Debt_;
import com.pureenee.model.Ordine;
import com.pureenee.model.Ordine_;
import com.pureenee.model.Prodotto;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.model.TipoProdotto;
import com.pureenee.objects.OrdineBean;
import com.pureenee.objects.ProdottoBean;
import com.pureenee.objects.ProdottoDealBean;
import com.pureenee.objects.ProdottoOrdineBean;
import com.pureenee.objects.TipoProdottoBean;

import java.util.ArrayList;
import java.util.List;

import io.objectbox.Box;
import io.objectbox.query.QueryBuilder;

public class OrdineService {

    Box<Ordine> ordineBox;
    Box<ProdottoDeal> prodottoDealBox;
    Box<ProdottoOrdine> prodottoOrdineBox;
    Box<Customer> customerBox;
    Box<Debt> debtBox;


    public OrdineService(){
        this.ordineBox = ObjectBox.get().boxFor(Ordine.class);
        this.prodottoDealBox = ObjectBox.get().boxFor(ProdottoDeal.class);
        this.customerBox = ObjectBox.get().boxFor(Customer.class);
        this.prodottoOrdineBox = ObjectBox.get().boxFor(ProdottoOrdine.class);
        this.debtBox = ObjectBox.get().boxFor(Debt.class);
    }

    public void insertOrdine(OrdineBean ordineBean, int flagDebito){
        Ordine ordine = new Ordine();
        ordine.setDataOrdine(ordineBean.getDataOrdine());
        ordine.setTotale(ordineBean.getTotale());
        ordine.setTotalePagato(ordineBean.getTotalePagato());

        Customer cliente = customerBox.get(ordineBean.getCustomerBean().getId());
        ordine.setCustomer(cliente);

        for (ProdottoOrdineBean pOBean:ordineBean.getProdottiOrdine()) {
            ProdottoOrdine pO = new ProdottoOrdine();
            pO.setQuantitativoEffettivo(pOBean.getQuantitativoEffettivo());
            pO.setQuantitativoPrevisto(pOBean.getQuantitativoPrevisto());

            ProdottoDealBean pDealBean = pOBean.getProdottoDeal();

            ProdottoDeal pDeal = prodottoDealBox.get(pDealBean.getId());

            double importoRientrato = pDeal.getImportoRientrato() + (pO.getQuantitativoPrevisto() * pDeal.getPrezzoDettaglio());

            pDeal.setQuantitativoProdottoDeal(pDeal.getQuantitativoProdottoDeal() - pO.getQuantitativoEffettivo());
            pDeal.setDisponibilitaMercato(pDeal.getDisponibilitaMercato() - pO.getQuantitativoEffettivo());
            pDeal.setImportoRientrato(importoRientrato);

            pO.setOrdine(ordine);
            pO.setProdottoDeal(pDeal);
            prodottoDealBox.put(pDeal);
            prodottoOrdineBox.put(pO);

        }

        if(flagDebito == FlagDebito.DEBITO.getCode()){
            double importoDebito = ordine.getTotale() - ordine.getTotalePagato();
            Debt debito = new Debt();
            debito.setAttivo(true);
            debito.setImportoDebito(importoDebito);
            debtBox.put(debito);
            ordine.setDebito(debito);
        }

        ordineBox.put(ordine);

    }

    public List<Ordine> getAllOrdiniWithDebiti(){
        List<Ordine> allOrdini = ordineBox.getAll();
        List<Ordine> ordiniList = new ArrayList<>();

        for (Ordine ordine:allOrdini) {
            if(ordine.hasDebito()) ordiniList.add(ordine);
        }

        return ordiniList;
    }

}
