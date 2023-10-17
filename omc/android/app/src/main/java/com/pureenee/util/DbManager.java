package com.pureenee.util;

import android.content.Context;

import androidx.room.Database;
import androidx.room.Room;
import androidx.room.RoomDatabase;

import com.pureenee.dao.CustomerDAO;
import com.pureenee.dao.DealDao;
import com.pureenee.dao.DebtDAO;
import com.pureenee.dao.OrdineDAO;
import com.pureenee.dao.ProdottoDAO;
import com.pureenee.dao.ProdottoDealDAO;
import com.pureenee.dao.ProdottoOrdineDAO;
import com.pureenee.dao.TipoProdottoDAO;
import com.pureenee.dao.UserDAO;
import com.pureenee.model.Customer;
import com.pureenee.model.Deal;
import com.pureenee.model.Debt;
import com.pureenee.model.Ordine;
import com.pureenee.model.Prodotto;
import com.pureenee.model.ProdottoDeal;
import com.pureenee.model.ProdottoOrdine;
import com.pureenee.model.TipoProdotto;
import com.pureenee.model.User;

@Database(entities = {
        Customer.class,
        Deal.class,
        Debt.class,
        Ordine.class,
        Prodotto.class,
        ProdottoDeal.class,
        ProdottoOrdine.class,
        TipoProdotto.class,
        User.class
}, version = 1)
public abstract class DbManager extends RoomDatabase {

    private static DbManager INSTANCE;

    public abstract CustomerDAO customerDAO();
    public abstract DealDao dealDao();
    public abstract DebtDAO debtDAO();
    public abstract OrdineDAO ordineDAO();
    public abstract ProdottoDAO prodottoDAO();
    public abstract ProdottoDealDAO prodottoDealDAO();
    public abstract ProdottoOrdineDAO prodottoOrdineDAO();
    public abstract TipoProdottoDAO tipoProdottoDAO();
    public abstract UserDAO userDao();

    public static DbManager getInMemoryDatabase(Context context) {
        if (INSTANCE == null) {
            INSTANCE =
                    Room.inMemoryDatabaseBuilder(context.getApplicationContext(), DbManager.class)
                            .allowMainThreadQueries()
                            .build();
        }
        return INSTANCE;
    }
    public static DbManager getDatabase(Context context) {
        if (INSTANCE == null) {
            INSTANCE =
                    Room.databaseBuilder(context.getApplicationContext(), DbManager.class, "omc")
                            .allowMainThreadQueries()
                            .build();
        }
        return INSTANCE;
    }
    public static void destroyInstance() {
        INSTANCE = null;
    }
}


