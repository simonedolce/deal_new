package com.pureenee.service;

import com.pureenee.box.ObjectBox;
import com.pureenee.model.Customer;
import com.pureenee.model.Debt;
import com.pureenee.model.Ordine;
import com.pureenee.model.SanamentoDebito;
import com.pureenee.objects.CustomerBean;
import com.pureenee.objects.DebtBean;
import com.pureenee.objects.OrdineBean;
import com.pureenee.objects.SanamentoDebitoBean;

import java.util.ArrayList;
import java.util.List;

import io.objectbox.Box;

public class CustomerService {

    Box<Customer> customerBox;
    Box<SanamentoDebito> sanamentoDebitoBox;
    Box<Ordine> ordineBox;
    Box<Debt> debtBox;

    public CustomerService(){
        this.customerBox = ObjectBox.get().boxFor(Customer.class);
        this.ordineBox = ObjectBox.get().boxFor(Ordine.class);
        this.sanamentoDebitoBox = ObjectBox.get().boxFor(SanamentoDebito.class);
        this.debtBox = ObjectBox.get().boxFor(Debt.class);
    }

    public CustomerBean toBean(Customer customer){
        CustomerBean bean = new CustomerBean();
        bean.setNome(customer.getNome());
        bean.setId(customer.getId());
        return bean;
    }

    public Customer insert(CustomerBean customerBean){
        Customer customer = new Customer();
        customer.setNome(customerBean.getNome());
        long newId = customerBox.put(customer);
        return customerBox.get(newId);
    }

    /**
     * Controlla se ci sono nuovi sanamenti e li salva a db
     * @param customerBean
     */
    public void sanaDebitiCustomer(CustomerBean customerBean){
        for (OrdineBean ordineBean:customerBean.getOrdini()) {
            boolean changes = false;
            DebtBean debtBean = ordineBean.getDebito();
            Debt debt = this.debtBox.get(debtBean.getId());
            for(SanamentoDebitoBean sanamentoDebitoBean : ordineBean.getDebito().getSanamenti()){
                // ID = 0 : NUOVO SANAMENTO
                if(sanamentoDebitoBean.getId() == 0){
                    changes = true;

                    SanamentoDebito sanamentoDebito = new SanamentoDebito();
                    sanamentoDebito.setDataSanamento(sanamentoDebitoBean.getDataSanamento());
                    sanamentoDebito.setImportoSanamento(sanamentoDebitoBean.getImportoSanamento());
                    sanamentoDebito.setDebito(debt);
                    this.sanamentoDebitoBox.put(sanamentoDebito);

                    debt.addSanamento(sanamentoDebito);

                }
            }

            if(changes){
                debt.setAttivo(debtBean.isAttivo());
                this.debtBox.put(debt);
            }

        }
    }

    /**
     * Ritorna tutti i clienti che hanno debiti attivi
     *
     * @return customers
     */
    public List<Customer> selectCustomerConDebiti(){
        List<Customer> customers = new ArrayList<>();
        for (Customer cliente : customerBox.getAll()) {
            for (Ordine ordine : cliente.getOrdini()) {
                if(ordine.hasDebito()){
                    customers.add(cliente);
                    break;
                }
            }
        }
        return customers;
    }

    public List<Customer> getAll(){
        return customerBox.getAll();
    }
}
