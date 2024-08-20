export enum ColorType {
  None = "None",
  White = "White",
  Black = "Black",
}

export class Color {
  value: ColorType;

  constructor(value: ColorType) {
    this.value = value;
  }

  public into(): number {
    return Object.values(ColorType).indexOf(this.value);
  }

  public static from(index: number): Color {
    const item = Object.values(ColorType)[index];
    return new Color(item);
  }

  public isNone(): boolean {
    return this.value === ColorType.None;
  }
}
