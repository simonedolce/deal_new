package com.pureenee.service;

import com.pureenee.box.ObjectBox;
import com.pureenee.model.Customer;
import com.pureenee.model.Debt;
import com.pureenee.model.Ordine;
import com.pureenee.model.Prodotto;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.model.SanamentoDebito;
import com.pureenee.model.TipoProdotto;
import com.pureenee.objects.CustomerBean;
import com.pureenee.objects.DebtBean;
import com.pureenee.objects.OrdineBean;
import com.pureenee.objects.ProdottoBean;
import com.pureenee.objects.ProdottoDealBean;
import com.pureenee.objects.ProdottoOrdineBean;
import com.pureenee.objects.SanamentoDebitoBean;
import com.pureenee.objects.TipoProdottoBean;

import java.util.ArrayList;
import java.util.List;

import io.objectbox.Box;

public class DebtService {
    Box<Debt> debtBox;
    CustomerService customerService;

    public DebtService(){
        this.debtBox = ObjectBox.get().boxFor(Debt.class);
        customerService = new CustomerService();
    }

    /**
     * La funzione ritorna Cliente - Ordine - Debito
     * filtrati
     * @return
     */
    public List<CustomerBean> getAllDebiti(){

        // Recupero una lista di clienti filtrati (quelli indebitati)
        List<Customer> clientiConDebiti = customerService.selectCustomerConDebiti();
        List<CustomerBean> beans = new ArrayList<>();
        for (Customer cliente: clientiConDebiti) {
            CustomerBean bean = new CustomerBean();
            bean.setId(cliente.getId());
            bean.setNome(cliente.getNome());

            // Recupero una lista di ordini filtrati (quelli con debito)
            List<Ordine> ordiniConDebiti = ordineConDebitiFromCliente(cliente);
            List<OrdineBean> ordiniConDebitiBeans = new ArrayList<>();

            for (Ordine oDebito : ordiniConDebiti) {
                OrdineBean ordineBean = new OrdineBean();
                ordineBean.setId(oDebito.getId());
                ordineBean.setDataOrdine(oDebito.getDataOrdine());
                ordineBean.setTotale(oDebito.getTotale());
                ordineBean.setTotalePagato(oDebito.getTotalePagato());

                DebtBean debtBean = new DebtBean();
                debtBean.setId(oDebito.getDebito().getId());
                debtBean.setIsAttivo(oDebito.getDebito().isAttivo());
                debtBean.setImportoDebito(oDebito.getDebito().getImportoDebito());


                if(oDebito.getDebito().getSanamenti().size() > 0){
                    List<SanamentoDebito> sanamentoList = oDebito.getDebito().getSanamenti();
                    List<SanamentoDebitoBean> sanamentoBeanList = new ArrayList<>();

                    for (SanamentoDebito sDebito:sanamentoList) {
                        SanamentoDebitoBean sanamentoBean = new SanamentoDebitoBean();
                        sanamentoBean.setId(sDebito.getId());
                        sanamentoBean.setDataSanamento(sDebito.getDataSanamento());
                        sanamentoBean.setImportoSanamento(sDebito.getImportoSanamento());
                        sanamentoBeanList.add(sanamentoBean);
                    }

                    debtBean.setSanamentoBeans(sanamentoBeanList);
                }

                ordineBean.setDebito(debtBean);

                for (ProdottoOrdine pOrdine : oDebito.getProdottiOrdine()) {
                    ProdottoOrdineBean pOrdineBean = new ProdottoOrdineBean();
                    pOrdineBean.setId(pOrdine.getId());
                    pOrdineBean.setQuantitativoEffettivo(pOrdine.getQuantitativoEffettivo());
                    pOrdineBean.setQuantitativoPrevisto(pOrdine.getQuantitativoPrevisto());

                    ProdottoDeal pDeal = pOrdine.getProdottoDeal();

                    ProdottoDealBean pDealBean = new ProdottoDealBean();
                    pDealBean.setId(pDeal.getId());
                    pDealBean.setPrezzoDettaglio(pDeal.getPrezzoDettaglio());
                    pDealBean.setPrezzoIngrosso(pDeal.getPrezzoIngrosso());
                    pDealBean.setImportoRientrato(pDeal.getImportoRientrato());
                    pDealBean.setImportoInvestito(pDeal.getImportoInvestito());
                    pDealBean.setDisponibilitaPersonaleIniziale(pDeal.getDisponibilitaPersonaleIniziale());
                    pDealBean.setDisponibilitaPersonale(pDeal.getDisponibilitaPersonale());
                    pDealBean.setDisponibilitaMercato(pDeal.getDisponibilitaMercato());

                    pDealBean.setDisponibilitaMercatoIniziale(pDeal.getDisponibilitaMercatoIniziale());
                    pDealBean.setQuantitativoProdottoDeal(pDeal.getQuantitativoProdottoDeal());
                    pDealBean.setQuantitativoProdottoDealIniziale(pDeal.getQuantitativoProdottoDealIniziale());

                    Prodotto prodotto = pDeal.getProdotto();
                    TipoProdotto tipoProdotto = pDeal.getProdotto().getTipoProdotto();

                    ProdottoBean prodottoBean = new ProdottoBean();
                    TipoProdottoBean tipoProdottoBean = new TipoProdottoBean();

                    tipoProdottoBean.setId(tipoProdotto.getId());
                    tipoProdottoBean.setDescrizione(tipoProdotto.getDescrizione());

                    prodottoBean.setId(prodotto.getId());
                    prodottoBean.setNomeProdotto(prodotto.getNomeProdotto());
                    prodottoBean.setTipoProdotto(tipoProdottoBean);

                    pDealBean.setProdottoBean(prodottoBean);

                    pOrdineBean.setProdottoDeal(pDealBean);
                    ordineBean.addProdottoOrdine(pOrdineBean);
                }
                ordiniConDebitiBeans.add(ordineBean);
            }
            bean.setOrdini(ordiniConDebitiBeans);
            beans.add(bean);
        }

        return beans;
    }

    public List<Ordine> ordineConDebitiFromCliente(Customer customer){
        List<Ordine> ordini = new ArrayList<>();
        for (Ordine ordine: customer.getOrdini()) {
            if(ordine.hasGotDebito()){
                ordini.add(ordine);
            }
        }
        return ordini;
    }



}
