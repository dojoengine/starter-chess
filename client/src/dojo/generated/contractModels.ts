/* Autogenerated file. Do not edit manually. */

import { defineComponent, Type as RecsType, World } from "@dojoengine/recs";

export type ContractComponents = Awaited<
  ReturnType<typeof defineContractComponents>
>;

export function defineContractComponents(world: World) {
  return {
    Game: (() => {
      return defineComponent(
        world,
        {
          id: RecsType.Number,
          over: RecsType.Boolean,
          color: RecsType.Number,
          whites: RecsType.BigInt,
          blacks: RecsType.BigInt,
          pieces: RecsType.BigInt,
        },
        {
          metadata: {
            name: "dojo_starter_chess-Game",
            types: ["u32", "bool", "u8", "u64", "u64", "felt252"],
            customTypes: [],
          },
        },
      );
    })(),
    Player: (() => {
      return defineComponent(
        world,
        {
          game_id: RecsType.Number,
          color: RecsType.Number,
          id: RecsType.BigInt,
          name: RecsType.BigInt,
        },
        {
          metadata: {
            name: "dojo_starter_chess-Player",
            types: ["u32", "u8", "felt252", "felt252"],
            customTypes: [],
          },
        },
      );
    })(),
  };
}
