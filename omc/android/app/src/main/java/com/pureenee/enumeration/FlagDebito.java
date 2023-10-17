package com.pureenee.enumeration;

public enum FlagDebito {
    DEBITO(0),
    SCONTO(1),
    PAGATO(2);

    private final int code;

    FlagDebito(int code) {
        this.code = code;
    }

    public int getCode(){
        return code;
    }

}


