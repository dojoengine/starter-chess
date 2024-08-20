// Core imports

use core::debug::PrintTrait;

// Internal imports

use chess::elements::pieces::interface::PieceTrait;
use chess::types::color::{Color, ColorTrait};
use chess::helpers::math::Math;
use chess::helpers::masker::Masker;
use chess::helpers::mapper::Mapper;
use chess::helpers::bitmap::Bitmap;

impl Pawn of PieceTrait {
    #[inline]
    fn can(index: u8, from: u8, to: u8, whites: u64, blacks: u64) -> bool {
        // [Check] The new position is a valid one
        let (from_row, from_col) = Mapper::decompose(from);
        let (to_row, to_col) = Mapper::decompose(to);
        let color: Color = ColorTrait::from(index);
        let d_row_abs = Math::sub_abs(from_row, to_row);
        let d_col_abs = Math::sub_abs(from_col, to_col);
        let is_valid_free = match color {
            Color::White => {
                from_col == to_col && ((from_row == 1 && to_row == 3) || (from_row + 1 == to_row))
            },
            Color::Black => {
                from_col == to_col && ((from_row == 6 && to_row == 4) || (from_row == to_row + 1))
            },
            _ => false
        };
        let is_valid_occupied = match color {
            Color::White => d_col_abs == 1 && d_row_abs == 1 && from_row < to_row,
            Color::Black => d_col_abs == 1 && d_row_abs == 1 && from_row > to_row,
            _ => false
        };
        // [Check] The path to go is free
        let mask = Masker::compute_mask(from, to);
        let is_free = (whites | blacks) & mask == 0;
        // [Check] The final position can be taken
        let is_available = match color {
            Color::White => !Bitmap::get_bit_at(whites, (to - 1)),
            Color::Black => !Bitmap::get_bit_at(blacks, (to - 1)),
            _ => false,
        };
        let is_occupied = match color {
            Color::White => Bitmap::get_bit_at(blacks, (to - 1)),
            Color::Black => Bitmap::get_bit_at(whites, (to - 1)),
            _ => false,
        };
        // [Return] Move validity
        is_available
            && is_free
            && ((is_valid_free && !is_occupied) || (is_valid_occupied && is_occupied))
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::Pawn;

    #[test]
    fn test_pieces_pawn_success() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000010_00000000_00000000_00000000;
        assert_eq!(Pawn::can(index, 9, 25, whites, blacks), true);
    }

    #[test]
    fn test_pieces_pawn_eat_success() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000000_00000010_00000000_00000000;
        assert_eq!(Pawn::can(index, 9, 18, whites, blacks), true);
    }

    #[test]
    fn test_pieces_pawn_not_valid() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000001_00000000_00000000_00000000;
        assert_eq!(Pawn::can(index, 9, 25, whites, blacks), false);
    }

    #[test]
    fn test_pieces_pawn_not_free() {
        let index = 9; // [A2]
        let whites = 0b00000000_00000001_00000000_00000000;
        let blacks = 0b00000010_00000000_00000000_00000000;
        assert_eq!(!Pawn::can(index, 9, 25, whites, blacks), true);
    }

    #[test]
    fn test_pieces_pawn_not_available() {
        let index = 9; // [A2]
        let whites = 0b00000001_00000000_00000000_00000000;
        let blacks = 0;
        assert_eq!(!Pawn::can(index, 9, 25, whites, blacks), true);
    }
}
