module coin::ayden_coin;

use sui::coin::{create_currency, TreasuryCap, Coin,mint,burn};

public struct AYDEN_COIN has drop{}

fun init(witness: AYDEN_COIN,ctx: &mut TxContext){
    let (treasury,metadata) = create_currency(witness, 9, b"ADC", b"AydenCoin", b"AydenCoin Desciption", option::none(), ctx);
    transfer::public_freeze_object(metadata);
    transfer::public_transfer(treasury,tx_context::sender(ctx));
}

public entry fun mints(treasury:&mut TreasuryCap<AYDEN_COIN>,amount:u64,recipient:address,ctx:&mut TxContext){
    let coins = mint(treasury,amount,ctx);
    transfer::public_transfer(coins,recipient);
}

public entry fun burns(treasury:&mut TreasuryCap<AYDEN_COIN>,ayden_coin:Coin<AYDEN_COIN>){
   burn(treasury,ayden_coin);
}






