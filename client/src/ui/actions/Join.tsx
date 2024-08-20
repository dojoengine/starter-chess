import { useDojo } from "@/dojo/useDojo";
import { useCallback, useMemo, useState } from "react";
import { Account } from "starknet";
import { Button } from "@/ui/elements/button";
import { usePlayer } from "@/hooks/usePlayer";
import { useNavigate } from "react-router-dom";
import { Color, ColorType } from "@/dojo/types/color";
import { Input } from "../elements/input";

export const Join = ({ gameId }: { gameId: number }) => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { join },
    },
  } = useDojo();

  const { player: white } = usePlayer({
    gameId,
    color: new Color(ColorType.White),
  });
  const { player: black } = usePlayer({
    gameId,
    color: new Color(ColorType.Black),
  });

  const [isLoading, setIsLoading] = useState(false);
  const [name, setName] = useState("");

  const navigate = useNavigate();

  const setGameQueryParam = useCallback(
    (id: string) => navigate("?id=" + id, { replace: true }),
    [navigate],
  );

  const handleClick = useCallback(async () => {
    setIsLoading(true);
    try {
      await join({
        account: account as Account,
        gameId,
        name,
      });
    } finally {
      setIsLoading(false);
      setGameQueryParam(gameId.toString());
    }
  }, [account, gameId, name]);

  const disabled = useMemo(() => {
    return (
      !account ||
      !master ||
      account === master ||
      name === "" ||
      white?.id == account.address ||
      !!black?.id
    );
  }, [account, master, name, white, black]);

  return (
    <div className="flex gap-4 w-full">
      <Input
        className="grow"
        value={name}
        onChange={(e) => setName(e.target.value)}
        placeholder="Player name"
      />
      <Button
        disabled={disabled || isLoading}
        isLoading={isLoading}
        onClick={handleClick}
        className="text-xl"
      >
        Join
      </Button>
    </div>
  );
};
