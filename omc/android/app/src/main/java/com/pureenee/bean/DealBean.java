package com.pureenee.bean;

import android.os.Build;

import com.pureenee.model.Deal;
import com.pureenee.model.Debt;
import com.pureenee.model.Ordine;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.model.SanamentoDebito;

import org.modelmapper.ModelMapper;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

public class DealBean {


    private long id;

    private double importoTotaleRientratoPrevisto;

    private double importoTotaleRientrato;

    private double disponibilitaTotaleMercato;

    private double disponibilitaTotalePersonale;

    private double disponibilitaTotalePersonaleIniziale;

    private double disponibilitaTotaleMercatoIniziale;

    /**
     * L'importo totale - i debiti totali
     */
    private double importoTotaleReale;

    private long dataDeal;

    private int giorniPassati;

    List<ProdottoDealBean> prodottiDeals;

    public DealBean(){
        this.prodottiDeals = new ArrayList<>();
    }

    public DealBean setData(Deal deal){
        this.id = deal.getId();
        this.dataDeal = dateToString(deal.getDataDeal());
        double importoTotaleRientrato = 0;
        double importoTotaleRientratoPrevisto = 0;
        double disponibilitaTotaleMercato = 0;
        double disponibilitaTotalePersonale = 0;
        double disponibilitaTotalePersonaleIniziale = 0;
        double disponibilitaTotaleMercatoIniziale = 0;
        double debitoTotale = 0;
        double totaleDisponibilitaVenduta = 0;
        double totaleDisponibilitaRealeVenduta = 0;

        for (ProdottoDeal pDeal:deal.getProdottiDeals()) {

            int sizeOrdiniProdotto = pDeal.getProdottiOrdine().size();

            // Se ha ordini
            if(sizeOrdiniProdotto > 0){
                // Informazioni sugli ordini
                for(ProdottoOrdine pOrdine : pDeal.getProdottiOrdine()){
                    importoTotaleRientrato += pOrdine.getQuantitativoPrevisto() * pDeal.getPrezzoDettaglio();
                    totaleDisponibilitaVenduta += pOrdine.getQuantitativoPrevisto();
                    totaleDisponibilitaRealeVenduta += pOrdine.getQuantitativoEffettivo();
                }
            }

            importoTotaleRientratoPrevisto += pDeal.getDisponibilitaMercatoIniziale() * pDeal.getPrezzoDettaglio();
            disponibilitaTotaleMercato += pDeal.getDisponibilitaMercato();
            disponibilitaTotalePersonale += pDeal.getDisponibilitaPersonale();
            disponibilitaTotalePersonaleIniziale += pDeal.getDisponibilitaPersonaleIniziale();
            disponibilitaTotaleMercatoIniziale += pDeal.getDisponibilitaMercatoIniziale();
            ProdottoDealBean prodottoDealBean = new ProdottoDealBean().setData(pDeal);
            addProdottoDealBean(prodottoDealBean);
        }

        // Controllo i debiti totali
        for (Debt debito : deal.getDebiti()) {
            debitoTotale += debito.getDebitoAttuale();
        }

        double importoTotaleReale = importoTotaleRientrato;
        if(debitoTotale > 0) importoTotaleReale = importoTotaleReale - debitoTotale;

        this.importoTotaleReale = importoTotaleReale;
        this.importoTotaleRientrato = importoTotaleRientrato;
        this.importoTotaleRientratoPrevisto = importoTotaleRientratoPrevisto;
        this.disponibilitaTotaleMercato = disponibilitaTotaleMercatoIniziale - totaleDisponibilitaVenduta;
        this.disponibilitaTotalePersonale = disponibilitaTotalePersonale;
        this.disponibilitaTotalePersonaleIniziale = disponibilitaTotalePersonaleIniziale;
        this.disponibilitaTotaleMercatoIniziale = disponibilitaTotaleMercatoIniziale;
        return this;
    }

    public void addProdottoDealBean(ProdottoDealBean prodottoDealBean){
        this.prodottiDeals.add(prodottoDealBean);
    }


    public long dateToString(Date dataDeal){
        Calendar calendar = new GregorianCalendar();
        calendar.setTime(dataDeal);
        return calendar.getTimeInMillis();
    }

    public int ritornaGiorniPassati(Date dataDeal){
        Date oggi = new Date();
        return 0;
    }



}
