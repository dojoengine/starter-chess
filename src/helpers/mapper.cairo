// Core imports

use core::debug::PrintTrait;

// Internal imports

use chess::constants::DEFAULT_BOARD_SIZE;

// Errors

mod errors {
    const MAPPER_INVALID_POSITION: felt252 = 'Mapper: invalid position';
}

#[generate_trait]
impl Mapper of MapperTrait {
    #[inline]
    fn decompose(position: u8) -> (u8, u8) {
        let index = position - 1;
        let row = index / DEFAULT_BOARD_SIZE;
        let col = index % DEFAULT_BOARD_SIZE;
        (row, col)
    }

    #[inline]
    fn compose(row: u8, col: u8) -> u8 {
        let index = row * DEFAULT_BOARD_SIZE + col;
        index + 1
    }
}

#[generate_trait]
impl MapperAssert of AssertTrait {
    #[inline]
    fn assert_valid_position(position: u8) {
        assert(
            position > 0 && position <= DEFAULT_BOARD_SIZE * DEFAULT_BOARD_SIZE,
            errors::MAPPER_INVALID_POSITION
        );
    }
}

#[cfg(test)]
mod tests {
    // Core imports

    use core::debug::PrintTrait;

    // Local imports

    use super::{Mapper, DEFAULT_BOARD_SIZE};

    #[test]
    fn test_mapper_decompose() {
        let position: u8 = 0x12;
        let (row, col) = Mapper::decompose(position);
        assert_eq!(row, 0x2);
        assert_eq!(col, 0x1);
    }

    #[test]
    fn test_mapper_compose() {
        let row: u8 = 0x2;
        let col: u8 = 0x1;
        let position = Mapper::compose(row, col);
        assert_eq!(position, 0x12);
    }
}
