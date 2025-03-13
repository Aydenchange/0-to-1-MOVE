module nft::ayden_nft {
    use std::ascii::String;
    use std::string::utf8;
    use sui::display;
    use sui::package;

    public struct AYDEN_NFT has drop {}

    public struct NFT has key, store {
        id: UID,
        name: String,
    }

    fun init(witness: AYDEN_NFT, ctx: &mut TxContext) {
        let keys = vector[
            utf8(b"name"),
            utf8(b"image_url"),
        ];

        let values = vector[
            utf8(b"{name}"),
            utf8(b"https://avatars.githubusercontent.com/u/174395241"),
        ];

        let publisher = package::claim(witness,ctx);
        let mut dispaly = display::new_with_fields<NFT>(&publisher,keys,values,ctx);
        display::update_version(&mut dispaly);
        transfer::public_transfer(publisher, tx_context::sender(ctx));
        transfer::public_transfer(dispaly, tx_context::sender(ctx));
    }

    public entry fun mints(name: String, recipient: address, ctx: &mut TxContext) {
        let nft = NFT {
            id: object::new(ctx),
            name
        };
        transfer::public_transfer(nft, recipient);
    }
}




