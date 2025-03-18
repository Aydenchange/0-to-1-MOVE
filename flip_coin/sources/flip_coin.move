module flip_coin::flip_coin;

use coin::ayden_faucet::AYDEN_FAUCET;
use sui::balance::{Balance, zero};
use sui::coin::{Coin, into_balance, from_balance};
use sui::random::{Random, new_generator, generate_bool};
use sui::transfer::public_transfer;
use sui::tx_context::sender;

const EOverBalance: u64 = 0;
const EAbort: u64 = 100;

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
    assert!(amount <= game_pool.balance.value(), EOverBalance);
    let withdraw_amount = game_pool.balance.split(amount);
    transfer::public_transfer(from_balance(withdraw_amount, ctx), tx_context::sender(ctx));
}

entry fun play(
    game_pool: &mut GamePool,
    guess: bool,
    random: &Random,
    inCoin: Coin<AYDEN_FAUCET>,
    ctx: &mut TxContext
) {
    let game_value = game_pool.balance.value();
    let coin_value = inCoin.value();

    if (coin_value > game_value / 10) {
        abort EAbort
    };

    let mut gen = new_generator(random, ctx);
    let flag = generate_bool(&mut gen);
    if (flag == guess) {
        let win_balance = game_pool.balance.split(coin_value);
        public_transfer(from_balance(win_balance, ctx), sender(ctx));
        public_transfer(inCoin, sender(ctx));
    }else {
        game_pool.balance.join(into_balance(inCoin));
    }
}

