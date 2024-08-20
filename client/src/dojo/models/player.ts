import { ComponentValue } from "@dojoengine/recs";
import { shortenHex } from "@dojoengine/utils";
import { shortString } from "starknet";
import { Color } from "../types/color";

export class Player {
  public id: string;
  public gameId: number;
  public color: Color;
  public name: string;

  constructor(player: ComponentValue) {
    this.id = `0x${player.id.toString(16)}`.replace("0x0x", "0x");
    this.gameId = player.game_id;
    this.color = Color.from(player.color);
    this.name = shortString.decodeShortString(player.name);
  }

  public getShortAddress(): string {
    return shortenHex(this.id);
  }
}
