package com.pureenee.omc;
import static com.pureenee.util.JavaAPI.*;

import com.google.gson.Gson;
import android.os.Bundle;

import androidx.core.view.WindowCompat;

import com.pureenee.bean.ProdottoBean;
import com.pureenee.box.ObjectBox;
import com.pureenee.model.Customer;
import com.pureenee.model.Prodotto;
import com.pureenee.model.TipoProdotto;
import com.pureenee.model.User;
import com.pureenee.objects.CustomerBean;
import com.pureenee.objects.OrdineBean;
import com.pureenee.service.CustomerService;
import com.pureenee.service.DealService;
import com.pureenee.service.DebtService;
import com.pureenee.service.OrdineService;
import com.pureenee.service.ProdottoDealService;
import com.pureenee.service.ProdottoService;
import com.pureenee.service.TipoProdottoService;
import com.pureenee.service.UserService;
import com.pureenee.util.JavaAPI;
import com.pureenee.util.Security;
import org.json.JSONException;
import org.json.JSONObject;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Objects;
import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;


public class MainActivity extends FlutterActivity {

    private static final String CHANNEL_INIT = "com.example.omc/init";
    private static final String CHANNEL_PRODOTTO = "com.example.omc/crea_prodotto";
    private static final String CHANNEL_DEAL = "com.example.omc/deal";
    private static final String CHANNEL_CUSTOMER = "com.example.omc/customer";
    private static final String CHANNEL_ORDINE = "com.example.omc/ordine";
    private static final String CHANNEL_DEBT = "com.example.omc/debt";

    TipoProdottoService tipoProdottoService;
    ProdottoService prodottoService;
    DealService dealService;
    ProdottoDealService prodottoDealService;
    CustomerService customerService;
    OrdineService ordineService;
    DebtService debtService;
    UserService userService;


    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        // Registra i plugin con il FlutterEngine
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        WindowCompat.setDecorFitsSystemWindows(getWindow(), false);
        ObjectBox.init(this);

        tipoProdottoService = new TipoProdottoService();
        prodottoService = new ProdottoService();

        prodottoDealService = new ProdottoDealService();
        dealService = new DealService();
        userService = new UserService();
        customerService = new CustomerService();
        ordineService = new OrdineService();
        debtService = new DebtService();

        if(!userService.isUserActive()){
            tipoProdottoService.initTipoProdotto();
        }

        Gson gson = new Gson();
        JavaAPI javaAPI = new JavaAPI();

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_INIT)
                .setMethodCallHandler((call, result) -> {

                    if (call.method.equals(JavaAPI.IS_ACTIVE_USER)) {
                        result.success(isUserActive());
                    } else if(call.method.equals(JavaAPI.INSERT_USER)) {
                        String password = call.argument("password");
                        String confirmPassword = call.argument("confirmPassword");

                        if(Objects.equals(password, confirmPassword)){

                            try {
                                insertUser(password);
                                result.success("ok");
                            } catch (Exception e) {
                                e.printStackTrace();
                            }

                        }

                    }else if(call.method.equals(JavaAPI.COUNT_DEAL)){
                        result.success(countDeal());
                    } else {
                        result.notImplemented(); // Metodo non supportato
                    }
        });


        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_PRODOTTO).setMethodCallHandler((call, result) -> {

            if (call.method.equals(JavaAPI.GET_ALL_TIPO_PRODOTTO)) {
                List<TipoProdotto> tipoProdottos = tipoProdottoService.getAll();
                List<String> serializedList = new ArrayList<>();
                for (TipoProdotto tipoProdotto : tipoProdottos) {
                    serializedList.add(gson.toJson(tipoProdotto));
                }
                result.success(serializedList);
            }else if(call.method.equals(JavaAPI.INSERT_PRODOTTO)){
                String nomeProdotto = call.argument("nomeProdotto");
                String idTipoProdotto = call.argument("idTipoProdotto");

                if(nomeProdotto != null && idTipoProdotto != null){
                    TipoProdotto tipoProdotto = tipoProdottoService.find(Integer.parseInt(idTipoProdotto));
                    Prodotto prodotto = new Prodotto();
                    prodotto.setNomeProdotto(nomeProdotto);
                    prodotto.setTipoProdotto(tipoProdotto);
                    prodottoService.inserisciProdotto(prodotto);
                }
            } else if(call.method.equals(JavaAPI.GET_ALL_PRODOTTI)){
                List<String> prodottiSerialized = getAllProdotti();
                result.success(prodottiSerialized);
            }

        });

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_DEAL).setMethodCallHandler((call, result) -> {
            if (call.method.equals(JavaAPI.INSERT_DEAL)) {
                String jsonString = call.argument("jsonString");
                try {
                    if(jsonString != null){
                        JSONObject jsonObject = new JSONObject(jsonString);
                        dealService.createNewDeal(jsonObject);

                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                result.success(null);
            } else if (call.method.equals(JavaAPI.GET_ALL_DEAL)) {
                result.success(dealService.getElencoDealDataStringify());
            }else if (call.method.equals(JavaAPI.GET_DEAL)) {
               int idDeal = call.argument("idDeal");
               //getDeal(idDeal);

            }

        });


        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_CUSTOMER).setMethodCallHandler((call, result) -> {
            switch (call.method){
                case GET_ALL_CUSTOMER:
                    List<Customer> customers = customerService.getAll();
                    List<String> list = new ArrayList<>();

                    for (Customer c: customers) {
                        CustomerBean cBean = customerService.toBean(c);
                        list.add(gson.toJson(cBean));
                    }

                    result.success(list);
                    break;
                case INSERT_CUSTOMER:
                    HashMap<String,String> customerString = call.argument("customer");
                    assert customerString != null;
                    JSONObject jsonObject = new JSONObject(customerString);
                    CustomerBean bean = new CustomerBean();

                    try {
                        bean.fromJson(jsonObject);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    Customer customer = customerService.insert(bean);
                    CustomerBean newBean = customerService.toBean(customer);
                    result.success(gson.toJson(newBean));

                    break;
            }
        });

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_ORDINE).setMethodCallHandler((call, result) -> {
            switch (call.method){
                case INSERT_ORDINE :
                    HashMap<String,String> ordineString = call.argument("ordine");
                    int flagDebito = call.argument("flagDebito");
                    assert ordineString != null;
                    JSONObject jsonObject = new JSONObject(ordineString);

                    try {
                        OrdineBean bean = new OrdineBean().fromJson(jsonObject);
                        ordineService.insertOrdine(bean,flagDebito);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    break;
                }
        });

        new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), CHANNEL_DEBT).setMethodCallHandler((call, result) -> {
            switch (call.method) {
                case GET_ALL_DEBITI :
                    List<String> list = new ArrayList<>();
                    for (CustomerBean cBean : debtService.getAllDebiti()) {
                        list.add(gson.toJson(cBean));
                    }
                    result.success(list);
                    break;
                case SANAMENTO_DEBITI :
                    HashMap<String,String> customerString = call.argument("customer");
                    assert customerString != null;
                    JSONObject jsonObject = new JSONObject(customerString);

                    try {
                        CustomerBean customerBean = new CustomerBean().fromJson(jsonObject);
                        customerService.sanaDebitiCustomer(customerBean);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    result.success(true);
                    break;
            }
        });
    }

    private boolean isUserActive() {
        return userService.isUserActive();
    }

    private void insertUser(String password) throws NoSuchPaddingException, IllegalBlockSizeException, NoSuchAlgorithmException, BadPaddingException, InvalidKeyException {
        Security security = new Security();
        String bFish = security.encrypt(password);
        userService.insertUser(bFish);
    }

    private long countDeal(){
        return dealService.count();
    }


    private List<String> getAllProdotti(){
        List<String>  serializedObject = new ArrayList<>();

        List<Prodotto> prodottiList = prodottoService.getAllProdotti();

        for (Prodotto prodotto:prodottiList) {
            Gson gson = new Gson();
            ProdottoBean prodottoBean = new ProdottoBean().setData(prodotto);
            serializedObject.add(gson.toJson(prodottoBean));
        }

        return serializedObject;
    }


}
