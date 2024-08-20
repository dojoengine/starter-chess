import { Color, ColorType } from "./color";
import wPawn from "/assets/chess-pawn-white.png";
import bPawn from "/assets/chess-pawn-black.png";
import wRook from "/assets/chess-rook-white.png";
import bRook from "/assets/chess-rook-black.png";
import wKnight from "/assets/chess-knight-white.png";
import bKnight from "/assets/chess-knight-black.png";
import wBishop from "/assets/chess-bishop-white.png";
import bBishop from "/assets/chess-bishop-black.png";
import wQueen from "/assets/chess-queen-white.png";
import bQueen from "/assets/chess-queen-black.png";
import wKing from "/assets/chess-king-white.png";
import bKing from "/assets/chess-king-black.png";

export enum PieceType {
  None = "None",
  Pawn = "Pawn",
  Rook = "Rook",
  Knight = "Knight",
  Bishop = "Bishop",
  Queen = "Queen",
  King = "King",
}

export class Piece {
  value: PieceType;

  constructor(value: PieceType) {
    this.value = value;
  }

  public into(): number {
    return Object.values(PieceType).indexOf(this.value);
  }

  public static from(index: number): { piece: PieceType; color: ColorType } {
    switch (index) {
      case 0:
        return { piece: PieceType.Rook, color: ColorType.White };
      case 1:
        return { piece: PieceType.Knight, color: ColorType.White };
      case 2:
        return { piece: PieceType.Bishop, color: ColorType.White };
      case 3:
        return { piece: PieceType.King, color: ColorType.White };
      case 4:
        return { piece: PieceType.Queen, color: ColorType.White };
      case 5:
        return { piece: PieceType.Bishop, color: ColorType.White };
      case 6:
        return { piece: PieceType.Knight, color: ColorType.White };
      case 7:
        return { piece: PieceType.Rook, color: ColorType.White };
      case 8:
      case 9:
      case 10:
      case 11:
      case 12:
      case 13:
      case 14:
      case 15:
        return { piece: PieceType.Pawn, color: ColorType.White };
      case 16:
      case 17:
      case 18:
      case 19:
      case 20:
      case 21:
      case 22:
      case 23:
        return { piece: PieceType.Pawn, color: ColorType.Black };
      case 24:
        return { piece: PieceType.Rook, color: ColorType.Black };
      case 25:
        return { piece: PieceType.Knight, color: ColorType.Black };
      case 26:
        return { piece: PieceType.Bishop, color: ColorType.Black };
      case 27:
        return { piece: PieceType.King, color: ColorType.Black };
      case 28:
        return { piece: PieceType.Queen, color: ColorType.Black };
      case 29:
        return { piece: PieceType.Bishop, color: ColorType.Black };
      case 30:
        return { piece: PieceType.Knight, color: ColorType.Black };
      case 31:
        return { piece: PieceType.Rook, color: ColorType.Black };
      default:
        return { piece: PieceType.None, color: ColorType.Black };
    }
  }

  public isNone(): boolean {
    return this.value === PieceType.None;
  }

  getImage(color: ColorType): string {
    const isWhite = color == ColorType.White;
    switch (this.value) {
      case PieceType.Pawn:
        return isWhite ? wPawn : bPawn;
      case PieceType.Rook:
        return isWhite ? wRook : bRook;
      case PieceType.Knight:
        return isWhite ? wKnight : bKnight;
      case PieceType.Bishop:
        return isWhite ? wBishop : bBishop;
      case PieceType.Queen:
        return isWhite ? wQueen : bQueen;
      case PieceType.King:
        return isWhite ? wKing : bKing;
      default:
        return "";
    }
  }
}
