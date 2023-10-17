package com.pureenee.repository;

import android.content.Context;

import com.pureenee.model.Deal;
import com.pureenee.util.DbManager;

import java.util.List;

public class DealRepository extends BaseRepository {
    public DealRepository(Context context) {
        super(context);
    }

    public int countDeal(){
        return this.dbManager.dealDao().getAll().size();
    }

    public List<Deal> getAll(){
        return dbManager.dealDao().getAll();
    }

    public long insertDeal(Deal deal){
        long idDeal = dbManager.dealDao().insert(deal);
        return idDeal;
    }

    public Deal get(int id){
        return dbManager.dealDao().getFromId(id);
    }

}
