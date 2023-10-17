package com.pureenee.repository;

import android.content.Context;

import com.pureenee.util.DbManager;

public class BaseRepository {

    protected Context context;
    protected DbManager dbManager;

    public BaseRepository(Context context) {
        this.context = context;
        this.dbManager = DbManager.getDatabase(this.context);;
    }
}
