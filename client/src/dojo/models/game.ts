import { ComponentValue } from "@dojoengine/recs";
import { Color, ColorType } from "../types/color";
import { Packer } from "../helpers/packer";
import { DEFAULT_BOARD_SIZE, PIECE_BIT_COUNT } from "../constants";
import { Piece, PieceType } from "../types/piece";

export class Game {
  public id: number;
  public over: boolean;
  public color: Color;
  public whites: number[];
  public blacks: number[];
  public pieces: { piece: PieceType; color: ColorType; position: number }[];

  constructor(game: ComponentValue) {
    this.id = game.id;
    this.over = !!game.over;
    this.color = Color.from(game.color);
    this.whites = game.whites;
    this.blacks = game.blacks;
    this.pieces = Packer.unpack(game.pieces, BigInt(PIECE_BIT_COUNT)).map(
      (position, index) => {
        const { piece, color } = Piece.from(index);
        return { piece, color, position };
      },
    );
  }

  getSize(): number {
    return DEFAULT_BOARD_SIZE;
  }

  getIndex(x: number, y: number): number {
    return 1 + x + y * this.getSize();
  }

  getPositions(): { [key: number]: { piece: PieceType; color: ColorType } } {
    const positions: { [key: number]: { piece: PieceType; color: ColorType } } =
      {};
    this.pieces.forEach(({ piece, color, position }) => {
      positions[position] = { piece, color };
    });
    return positions;
  }

  getPieceId(index: number): number {
    return this.pieces.findIndex(({ position }) => position === index);
  }
}
