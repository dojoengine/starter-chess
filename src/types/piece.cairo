// Internal imports

use chess::elements::pieces;
use chess::types::color::Color;

// Errors

mod errors {
    const PIECE_INVALID_VALUE: felt252 = 'Piece: invalid value';
    const PIECE_INVALID_MOVE: felt252 = 'Piece: invalid move';
}

#[derive(Copy, Drop)]
enum Piece {
    None,
    Pawn,
    Rook,
    Knight,
    Bishop,
    Queen,
    King,
}

#[generate_trait]
impl PieceImpl of PieceTrait {
    #[inline]
    fn from(index: u8) -> (Piece, Color) {
        match index {
            0 => (Piece::Rook, Color::White),
            1 => (Piece::Knight, Color::White),
            2 => (Piece::Bishop, Color::White),
            3 => (Piece::Queen, Color::White),
            4 => (Piece::King, Color::White),
            5 => (Piece::Bishop, Color::White),
            6 => (Piece::Knight, Color::White),
            7 => (Piece::Rook, Color::White),
            8 => (Piece::Pawn, Color::White),
            9 => (Piece::Pawn, Color::White),
            10 => (Piece::Pawn, Color::White),
            11 => (Piece::Pawn, Color::White),
            12 => (Piece::Pawn, Color::White),
            13 => (Piece::Pawn, Color::White),
            14 => (Piece::Pawn, Color::White),
            15 => (Piece::Pawn, Color::White),
            16 => (Piece::Pawn, Color::Black),
            17 => (Piece::Pawn, Color::Black),
            18 => (Piece::Pawn, Color::Black),
            19 => (Piece::Pawn, Color::Black),
            20 => (Piece::Pawn, Color::Black),
            21 => (Piece::Pawn, Color::Black),
            22 => (Piece::Pawn, Color::Black),
            23 => (Piece::Pawn, Color::Black),
            24 => (Piece::Rook, Color::Black),
            25 => (Piece::Knight, Color::Black),
            26 => (Piece::Bishop, Color::Black),
            27 => (Piece::Queen, Color::Black),
            28 => (Piece::King, Color::Black),
            29 => (Piece::Bishop, Color::Black),
            30 => (Piece::Knight, Color::Black),
            31 => (Piece::Rook, Color::Black),
            _ => (Piece::None, Color::None),
        }
    }

    #[inline]
    fn indexes(self: Piece, color: Color) -> Array<u8> {
        match color {
            Color::White => match self {
                Piece::Pawn => array![8, 9, 10, 11, 12, 13, 14, 15],
                Piece::Rook => array![0, 7],
                Piece::Knight => array![1, 6],
                Piece::Bishop => array![2, 5],
                Piece::Queen => array![3],
                Piece::King => array![4],
                _ => array![],
            },
            Color::Black => match self {
                Piece::Pawn => array![16, 17, 18, 19, 20, 21, 22, 23],
                Piece::Rook => array![24, 31],
                Piece::Knight => array![25, 30],
                Piece::Bishop => array![26, 29],
                Piece::Queen => array![27],
                Piece::King => array![28],
                _ => array![],
            },
            _ => array![],
        }
    }

    #[inline]
    fn can(self: Piece, index: u8, from: u8, to: u8, whites: u64, blacks: u64) -> bool {
        match self {
            Piece::None => false,
            Piece::Pawn => pieces::pawn::Pawn::can(index, from, to, whites, blacks),
            Piece::Rook => pieces::rook::Rook::can(index, from, to, whites, blacks),
            Piece::Knight => pieces::knight::Knight::can(index, from, to, whites, blacks),
            Piece::Bishop => pieces::bishop::Bishop::can(index, from, to, whites, blacks),
            Piece::Queen => pieces::queen::Queen::can(index, from, to, whites, blacks),
            Piece::King => pieces::king::King::can(index, from, to, whites, blacks),
        }
    }
}

#[generate_trait]
impl PieceAssert of AssertTrait {
    #[inline]
    fn assert_is_valid(self: Piece) {
        assert(self != Piece::None.into(), errors::PIECE_INVALID_VALUE);
    }

    #[inline]
    fn assert_valid_move(self: Piece, index: u8, from: u8, to: u8, whites: u64, blacks: u64) {
        assert(self.can(index, from, to, whites, blacks), errors::PIECE_INVALID_MOVE);
    }
}

impl IntoPieceFelt252 of core::Into<Piece, felt252> {
    #[inline]
    fn into(self: Piece) -> felt252 {
        match self {
            Piece::None => 'NONE',
            Piece::Pawn => 'PAWN',
            Piece::Rook => 'ROOK',
            Piece::Knight => 'KNIGHT',
            Piece::Bishop => 'BISHOP',
            Piece::Queen => 'QUEEN',
            Piece::King => 'KING',
        }
    }
}

impl IntoPieceU8 of core::Into<Piece, u8> {
    #[inline]
    fn into(self: Piece) -> u8 {
        match self {
            Piece::None => 0,
            Piece::Pawn => 1,
            Piece::Rook => 2,
            Piece::Knight => 3,
            Piece::Bishop => 4,
            Piece::Queen => 5,
            Piece::King => 6,
        }
    }
}

impl IntoU8Piece of core::Into<u8, Piece> {
    #[inline]
    fn into(self: u8) -> Piece {
        let card: felt252 = self.into();
        match card {
            0 => Piece::None,
            1 => Piece::Pawn,
            2 => Piece::Rook,
            3 => Piece::Knight,
            4 => Piece::Bishop,
            5 => Piece::Queen,
            6 => Piece::King,
            _ => Piece::None,
        }
    }
}

impl PartialEqPiece of core::PartialEq<Piece> {
    #[inline]
    fn eq(lhs: @Piece, rhs: @Piece) -> bool {
        let left: u8 = (*lhs).into();
        let right: u8 = (*rhs).into();
        left == right
    }
}

impl PiecePrint of core::debug::PrintTrait<Piece> {
    #[inline]
    fn print(self: Piece) {
        let felt: felt252 = self.into();
        felt.print();
    }
}
