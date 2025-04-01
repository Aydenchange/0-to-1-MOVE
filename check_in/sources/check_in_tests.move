#[test_only]
module check_in::check_in_tests {
    use std::debug;
    use std::bcs;
    use std::hash::sha3_256;
    use std::ascii::string;
    // uncomment this line to import the module
    // use check_in::check_in;

    #[test]
    fun test_check_in() {
        // pass
        let flag_str= string(b"5~~4:v[s");
        let github_id = string(b"Aydenchange");

        let mut bcs_flag = bcs::to_bytes(&flag_str);
        vector::append<u8>(&mut bcs_flag, *github_id.as_bytes());

        debug::print(&sha3_256(bcs_flag));
        //assert!(flag == sha3_256(bcs_flag), ESTRING);
    }
}