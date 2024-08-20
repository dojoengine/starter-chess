import { useDojo } from "@/dojo/useDojo";
import { useMemo } from "react";
import { getEntityIdFromKeys } from "@dojoengine/utils";
import { useComponentValue } from "@dojoengine/react";
import { Entity } from "@dojoengine/recs";
import { Color } from "@/dojo/types/color";

export const usePlayer = ({
  gameId,
  color,
}: {
  gameId: number;
  color: Color;
}) => {
  const {
    setup: {
      clientModels: {
        Player,
        classes: { Player: PlayerClass },
      },
    },
  } = useDojo();

  const key = useMemo(
    () => getEntityIdFromKeys([BigInt(gameId), BigInt(color.into())]) as Entity,
    [gameId, color],
  );
  const component = useComponentValue(Player, key);
  const player = useMemo(() => {
    return component ? new PlayerClass(component) : null;
  }, [component]);

  return { player, key };
};
