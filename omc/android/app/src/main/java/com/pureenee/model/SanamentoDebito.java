package com.pureenee.model;

import io.objectbox.annotation.Entity;
import io.objectbox.annotation.Id;
import io.objectbox.relation.ToOne;

@Entity
public class SanamentoDebito {

    @Id
    long id;

    double importoSanamento;

    long dataSanamento;

    ToOne<Debt> debito;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public double getImportoSanamento() {
        return importoSanamento;
    }

    public void setImportoSanamento(double importoSanamento) {
        this.importoSanamento = importoSanamento;
    }

    public long getDataSanamento() {
        return dataSanamento;
    }

    public void setDataSanamento(long dataSanamento) {
        this.dataSanamento = dataSanamento;
    }

    public Debt getDebito() {
        return debito.getTarget();
    }

    public void setDebito(Debt debito) {
        this.debito.setTarget(debito);
    }
}
