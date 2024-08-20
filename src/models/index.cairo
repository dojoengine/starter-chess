#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Game {
    #[key]
    id: u32,
    over: bool,
    color: u8,
    whites: u64,
    blacks: u64,
    pieces: felt252,
}

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Player {
    #[key]
    game_id: u32,
    #[key]
    color: u8,
    id: felt252,
    name: felt252,
}
