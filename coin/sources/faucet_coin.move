module coin::ayden_faucet;

use sui::coin::{create_currency, TreasuryCap, Coin,burn, mint_and_transfer};

public struct AYDEN_FAUCET has drop{}

fun init(witness: AYDEN_FAUCET,ctx: &mut TxContext){
    let (treasury,metadata) = create_currency(witness, 9, b"ADF", b"AydenFaucet", b"AydenFaucet Desciption", option::none(), ctx);
    transfer::public_freeze_object(metadata);
    transfer::public_share_object(treasury);
}

public entry fun mints(treasury:&mut TreasuryCap<AYDEN_FAUCET>,amount:u64,recipient:address,ctx:&mut TxContext){
    mint_and_transfer(treasury,amount,recipient,ctx);
}

public entry fun burns(treasury:&mut TreasuryCap<AYDEN_FAUCET>,ayden_coin:Coin<AYDEN_FAUCET>){
    burn(treasury,ayden_coin);
}






