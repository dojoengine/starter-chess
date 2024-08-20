import { useDojo } from "@/dojo/useDojo";
import { useCallback, useMemo, useState } from "react";
import { Account } from "starknet";
import { Button } from "@/ui/elements/button";
import { useQueryParams } from "@/hooks/useQueryParams";
import { useActionStore } from "@/store/selection";
import { useGame } from "@/hooks/useGame";

export const Move = () => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { move },
    },
  } = useDojo();
  const { gameId } = useQueryParams();
  const { game } = useGame({ gameId });

  const [isLoading, setIsLoading] = useState(false);

  const { selection, to, resetSelection, resetTo } = useActionStore();

  const handleClick = useCallback(async () => {
    if (!account || !master || account === master || !selection || !to || !game)
      return;
    setIsLoading(true);
    try {
      await move({
        account: account as Account,
        gameId,
        pieceId: game.getPieceId(selection),
        to: to,
      });
    } finally {
      setIsLoading(false);
      resetSelection();
      resetTo();
    }
  }, [account, gameId, game, selection, to]);

  const disabled = useMemo(() => {
    return (
      !account ||
      !master ||
      account === master ||
      !selection ||
      !to ||
      !game ||
      game.over
    );
  }, [account, master, selection, to, game]);

  return (
    <Button
      disabled={disabled || isLoading}
      isLoading={isLoading}
      onClick={handleClick}
      className="text-xl"
    >
      Move
    </Button>
  );
};
