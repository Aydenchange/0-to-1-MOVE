module hello_move::hello_world;

use std::ascii::{String, string};
use sui::transfer::transfer;
use sui::tx_context:: sender;

public struct Hello has key{
    id:UID,
    say:String
}

fun init(ctx:&mut TxContext){
    let hello = Hello{
        id:object::new(ctx),
        say:string(b"AydenChange")
    };
    transfer(hello,sender(ctx));
}

