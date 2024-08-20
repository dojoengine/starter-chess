import { ContractComponents } from "./generated/contractModels";
import { overridableComponent } from "@dojoengine/recs";
import { Game } from "./models/game";
import { Player } from "./models/player";

export type ClientModels = ReturnType<typeof models>;

export function models({
  contractModels,
}: {
  contractModels: ContractComponents;
}) {
  return {
    ...contractModels,
    classes: {
      Player,
      Game,
    },
  };
}
