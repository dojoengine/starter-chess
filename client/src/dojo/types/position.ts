export class Position {
  public x: number;
  public y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  public add(position: Position): Position {
    return new Position(this.x + position.x, this.y + position.y);
  }

  public isEqual(position: Position): boolean {
    return this.x === position.x && this.y === position.y;
  }

  public isGe(position: Position): boolean {
    return this.x >= position.x && this.y >= position.y;
  }

  public isNull(): boolean {
    return this.isEqual(new Position(0, 0));
  }
}
