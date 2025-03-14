module flip_coin::flip_coin;

use coin::ayden_faucet::AYDEN_FAUCET;
use sui::balance::{Balance, zero};
use sui::coin;
use sui::coin::{Coin, into_balance};

public struct GamePool has key {
    id: UID,
    balance: Balance<AYDEN_FAUCET>
}

public struct AdminCap has key {
    id: UID
}

fun init(ctx: &mut TxContext) {
    let admincap = AdminCap { id: object::new(ctx) };
    let game_pool = GamePool { id: object::new(ctx), balance: zero<AYDEN_FAUCET>() };
    transfer::share_object(game_pool);
    transfer::transfer(admincap, tx_context::sender(ctx));
}

public entry fun deposit(ganme_pool: &mut GamePool, coin: Coin<AYDEN_FAUCET>) {
    let coin_balance = into_balance(coin);
    ganme_pool.balance.join(coin_balance);
}

public entry fun withdraw(_: &AdminCap, game_pool: &mut GamePool, amount: u64, ctx: &mut TxContext) {
    let withdraw_amount = game_pool.balance.split(amount);
    transfer::public_transfer(coin::from_balance(withdraw_amount, ctx), tx_context::sender(ctx));
}