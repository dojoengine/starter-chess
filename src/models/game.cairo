// Core imports

use core::debug::PrintTrait;
use core::array::ArrayTrait;

// Inernal imports

use chess::constants;
use chess::models::index::Game;
use chess::types::color::{Color, ColorTrait};
use chess::types::piece::{Piece, PieceTrait, PieceAssert};
use chess::helpers::bitmap::Bitmap;
use chess::helpers::mapper::{Mapper, MapperAssert};
use chess::helpers::packer::Packer;

mod errors {
    const GAME_NOT_EXISTS: felt252 = 'Game: does not exist';
    const GAME_NOT_STARTED: felt252 = 'Game: not started';
    const GAME_ALREADY_STARTED: felt252 = 'Game: already started';
    const GAME_IS_OVER: felt252 = 'Game: is over';
    const GAME_WRONG_TURN: felt252 = 'Game: wrong turn';
    const GAME_INVALID_MOVE: felt252 = 'Game: invalid move';
    const GAME_INVALID_PIECE: felt252 = 'Game: invalid piece';
}

#[generate_trait]
impl GameImpl of GameTrait {
    #[inline]
    fn new(id: u32) -> Game {
        Game {
            id,
            over: false,
            color: Color::None.into(),
            whites: constants::DEFAULT_WHITE_POSITIONS,
            blacks: constants::DEFAULT_BLACK_POSITIONS,
            pieces: constants::DEFAULT_PIECE_POSITIONS,
        }
    }

    #[inline]
    fn start(ref self: Game) {
        self.color = Color::White.into()
    }

    #[inline]
    fn assess_over(ref self: Game) {
        // [Check] King positions are not null
        let pieces: u256 = self.pieces.into();
        let mut indexes = Piece::King.indexes(Color::White);
        let index = indexes.pop_front().unwrap();
        let white: u16 = Packer::get(pieces, index, constants::PIECE_BIT_COUNT);
        let mut indexes = Piece::King.indexes(Color::Black);
        let index = indexes.pop_front().unwrap();
        let black: u16 = Packer::get(pieces, index, constants::PIECE_BIT_COUNT);
        self.over = black * white == 0;
    }

    #[inline]
    fn move(ref self: Game, index: u8, to: u8) {
        // [Check] Color turn
        let (piece, color) = PieceTrait::from(index);
        self.assert_color_turn(color);
        // [Check] Piece has a valid position
        let mut pieces: u256 = self.pieces.into();
        let from = Packer::get(pieces, index, constants::PIECE_BIT_COUNT);
        MapperAssert::assert_valid_position(from);
        // [Check] Target is a valid position
        MapperAssert::assert_valid_position(to);
        // [Check] Move validity
        piece.assert_valid_move(index, from, to, self.whites, self.blacks);
        // [Effect] Update positions
        self.whites = Bitmap::set_bit_at(self.whites, (from - 1), false);
        self.blacks = Bitmap::set_bit_at(self.blacks, (from - 1), false);
        self.whites = Bitmap::set_bit_at(self.whites, (to - 1), color == Color::White);
        self.blacks = Bitmap::set_bit_at(self.blacks, (to - 1), color == Color::Black);
        // [Effect] Update pieces
        match Packer::index(pieces, to, constants::PIECE_BIT_COUNT) {
            Option::Some(position_index) => {
                // [EFfect] Remove piece position
                pieces = Packer::set(pieces, position_index, constants::PIECE_BIT_COUNT, 0);
            },
            Option::None => {}
        };
        pieces = Packer::set(pieces, index, constants::PIECE_BIT_COUNT, to);
        self.pieces = pieces.try_into().unwrap();
        // [Effect] Color turn
        self.color = color.next().into();
    }
}

impl ZeroableGame of core::Zeroable<Game> {
    #[inline]
    fn zero() -> Game {
        Game { id: 0, over: false, color: 0, whites: 0, blacks: 0, pieces: 0, }
    }

    #[inline]
    fn is_zero(self: Game) -> bool {
        0 == self.pieces
    }

    #[inline]
    fn is_non_zero(self: Game) -> bool {
        !self.is_zero()
    }
}

#[generate_trait]
impl GameAssert of AssertTrait {
    #[inline]
    fn assert_exists(self: Game) {
        assert(self.is_non_zero(), errors::GAME_NOT_EXISTS);
    }

    #[inline]
    fn assert_is_started(self: Game) {
        assert(self.color != 0, errors::GAME_NOT_STARTED)
    }

    #[inline]
    fn assert_not_started(self: Game) {
        assert(self.color == 0, errors::GAME_ALREADY_STARTED);
    }

    #[inline]
    fn assert_not_over(self: Game) {
        assert(!self.over, errors::GAME_IS_OVER);
    }

    #[inline]
    fn assert_color_turn(self: Game, color: Color) {
        assert(self.color == color.into(), errors::GAME_WRONG_TURN);
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::constants;
    use super::{Game, GameTrait, AssertTrait};

    // Constants

    const GAME_ID: u32 = 1;

    #[test]
    fn test_game_new() {
        let game = GameTrait::new(GAME_ID);
        assert_eq!(game.id, GAME_ID);
    }
}
