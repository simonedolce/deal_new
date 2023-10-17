package com.pureenee.objects;

import android.content.Context;

import com.pureenee.model.Deal;

public class ElencoDeal extends Deal {

    private long idDeal;
    private double importoTotaleRientrato;
    private double importoTotaleRientratoPrevisto;
    private double disponibilitaTotaleMercato;
    private double disponibilitaTotalePersonale;
    private double disponibilitaTotalePersonaleIniziale;


    public ElencoDeal() {
    }

    public long getIdDeal() {
        return idDeal;
    }

    public void setIdDeal(long idDeal) {
        this.idDeal = idDeal;
    }

    public double getImportoTotaleRientrato() {
        return importoTotaleRientrato;
    }

    public void setImportoTotaleRientrato(double importoTotaleRientrato) {
        this.importoTotaleRientrato = importoTotaleRientrato;
    }

    public double getDisponibilitaTotaleMercato() {
        return disponibilitaTotaleMercato;
    }

    public void setDisponibilitaTotaleMercato(double disponibilitaTotaleMercato) {
        this.disponibilitaTotaleMercato = disponibilitaTotaleMercato;
    }

    public double getDisponibilitaTotalePersonale() {
        return disponibilitaTotalePersonale;
    }

    public void setDisponibilitaTotalePersonale(double disponibilitaTotalePersonale) {
        this.disponibilitaTotalePersonale = disponibilitaTotalePersonale;
    }

    public double getDisponibilitaTotalePersonaleIniziale() {
        return disponibilitaTotalePersonaleIniziale;
    }

    public void setDisponibilitaTotalePersonaleIniziale(double disponibilitaTotalePersonaleIniziale) {
        this.disponibilitaTotalePersonaleIniziale = disponibilitaTotalePersonaleIniziale;
    }

    public double getImportoTotaleRientratoPrevisto() {
        return importoTotaleRientratoPrevisto;
    }

    public void setImportoTotaleRientratoPrevisto(double importoTotaleRientratoPrevisto) {
        this.importoTotaleRientratoPrevisto = importoTotaleRientratoPrevisto;
    }
}
