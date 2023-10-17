package com.pureenee.model;

import java.util.List;

import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToMany;
import io.objectbox.relation.ToOne;

@Entity
public class Debt {

    @Id
    private long id;

    private double importoDebito;

    private boolean isAttivo;

    ToOne<Ordine> ordine;

    ToMany<SanamentoDebito> sanamenti;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getImportoDebito() {
        return importoDebito;
    }

    public void setImportoDebito(double importoDebito) {
        this.importoDebito = importoDebito;
    }

    public Ordine getOrdine(){
        return this.ordine.getTarget();
    }

    public void setOrdine(Ordine ordine){
        this.ordine.setTarget(ordine);
    }

    public void setOrdine(ToOne<Ordine> ordine) {
        this.ordine = ordine;
    }

    public boolean isAttivo() {
        return isAttivo;
    }

    public void setAttivo(boolean attivo) {
        isAttivo = attivo;
    }

    public List<SanamentoDebito> getSanamenti() {
        return sanamenti;
    }

    public void addSanamento(SanamentoDebito sanamentoDebito) {
        this.sanamenti.add(sanamentoDebito);
    }

    /**
     * Ritorna l'importo tenendo conto dei pagamenti ricevuti
     * @return
     */
    public double getDebitoAttuale(){
        double debitoAttuale = this.importoDebito;
        for (SanamentoDebito sanamento : this.getSanamenti()) {
            debitoAttuale -= sanamento.getImportoSanamento();
        }
        return debitoAttuale;
    }
}
