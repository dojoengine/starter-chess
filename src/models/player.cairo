// Inernal imports

use chess::constants;
use chess::models::index::Player;

mod errors {
    const PLAYER_NOT_EXIST: felt252 = 'Player: does not exist';
    const PLAYER_ALREADY_EXIST: felt252 = 'Player: already exist';
    const PLAYER_NOT_CALLER: felt252 = 'Player: not caller';
    const INVALID_NAME: felt252 = 'Player: invalid name';
}

#[generate_trait]
impl PlayerImpl of PlayerTrait {
    #[inline]
    fn new(game_id: u32, color_id: u8, player_id: felt252, name: felt252) -> Player {
        // [Check] Name is valid
        assert(name != 0, errors::INVALID_NAME);
        // [Return] Player
        Player { game_id, color_id, id: player_id, name, }
    }
}

#[generate_trait]
impl PlayerAssert of AssertTrait {
    #[inline]
    fn assert_exists(self: Player) {
        assert(self.is_non_zero(), errors::PLAYER_NOT_EXIST);
    }

    #[inline]
    fn assert_not_exists(self: Player) {
        assert(self.is_zero(), errors::PLAYER_ALREADY_EXIST);
    }

    #[inline]
    fn assert_is_caller(self: Player, caller: felt252) {
        assert(self.id == caller, errors::PLAYER_NOT_CALLER);
    }
}

impl ZeroablePlayerImpl of core::Zeroable<Player> {
    #[inline]
    fn zero() -> Player {
        Player { game_id: 0, color_id: 0, id: 0, name: 0, }
    }

    #[inline]
    fn is_zero(self: Player) -> bool {
        0 == self.name
    }

    #[inline]
    fn is_non_zero(self: Player) -> bool {
        !self.is_zero()
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::{Player, PlayerTrait, AssertTrait};

    // Constants

    const GAME_ID: u32 = 1;
    const COLOR_ID: u8 = 2;
    const PLAYER_ID: felt252 = 'ID';
    const PLAYER_NAME: felt252 = 'NAME';

    #[test]
    fn test_player_new() {
        let player = PlayerTrait::new(GAME_ID, COLOR_ID, PLAYER_ID, PLAYER_NAME);
        assert_eq!(player.game_id, GAME_ID);
        assert_eq!(player.color_id, COLOR_ID);
        assert_eq!(player.name, PLAYER_NAME);
    }
}

