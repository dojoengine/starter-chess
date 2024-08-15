// Core imports

use core::debug::PrintTrait;

// Internal imports

use chess::elements::pieces::interface::PieceTrait;
use chess::types::color::{Color, ColorTrait};
use chess::helpers::math::Math;
use chess::helpers::masker::Masker;
use chess::helpers::mapper::Mapper;
use chess::helpers::bitmap::Bitmap;

impl King of PieceTrait {
    #[inline]
    fn can(index: u8, from: u8, to: u8, whites: u64, blacks: u64) -> bool {
        // [Check] The new position is a valid one
        let (from_row, from_col) = Mapper::decompose(from);
        let (to_row, to_col) = Mapper::decompose(to);
        let d_row_abs = Math::sub_abs(from_row, to_row);
        let d_col_abs = Math::sub_abs(from_col, to_col);
        let is_valid = (d_row_abs == 0 || d_row_abs == 1) && (d_col_abs == 0 || d_col_abs == 1);
        // [Check] The final position can be taken
        let color: Color = ColorTrait::from(index);
        let is_available = match color {
            Color::White => !Bitmap::get_bit_at(whites, (to - 1)),
            Color::Black => !Bitmap::get_bit_at(blacks, (to - 1)),
            _ => false,
        };
        // [Return] Move validity
        is_valid && is_available
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::King;

    #[test]
    fn test_pieces_king_straight_success() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000000_00000000_00000010_00000000;
        assert_eq!(King::can(index, 9, 10, whites, blacks), true);
    }

    #[test]
    fn test_pieces_king_diagonal_success() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000000_00000010_00000000_00000000;
        assert_eq!(King::can(index, 9, 18, whites, blacks), true);
    }

    #[test]
    fn test_pieces_king_not_valid() {
        let index = 9; // [A2]
        let whites = 0;
        let blacks = 0b00000001_00000000_00000000_00000000;
        assert_eq!(King::can(index, 9, 26, whites, blacks), false);
    }

    #[test]
    fn test_pieces_king_not_available() {
        let index = 9; // [A2]
        let whites = 0b00000000_00000010_00000000_00000000;
        let blacks = 0;
        assert_eq!(King::can(index, 9, 18, whites, blacks), false);
    }
}
