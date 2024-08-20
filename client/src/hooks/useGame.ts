import { useDojo } from "@/dojo/useDojo";
import { useMemo } from "react";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useComponentValue } from "@dojoengine/react";
import { Entity } from "@dojoengine/recs";

export const useGame = ({ gameId }: { gameId: number | undefined }) => {
  const {
    setup: {
      clientModels: {
        Game,
        classes: { Game: GameClass },
      },
    },
  } = useDojo();

  const key = useMemo(
    () => getEntityIdFromKeys([BigInt(gameId || 0)]) as Entity,
    [gameId],
  );
  const component = useComponentValue(Game, key);
  const game = useMemo(() => {
    return component ? new GameClass(component) : null;
  }, [component]);
  return { game, key };
};
