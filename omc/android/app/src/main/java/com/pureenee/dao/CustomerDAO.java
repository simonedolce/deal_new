package com.pureenee.dao;

import androidx.room.Dao;
import androidx.room.Delete;
import androidx.room.Insert;
import androidx.room.Query;
import com.pureenee.model.Customer;
import java.util.List;


@Dao
public interface CustomerDAO {
    @Insert
    long insert(Customer customer);

    @Query("SELECT * FROM Customer WHERE id = :id")
    Customer getFromId(long id);

    @Delete
    void delete(Customer customer);

    @Query("SELECT * FROM Customer")
    List<Customer> getAll();
}
