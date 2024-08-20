import { useDojo } from "@/dojo/useDojo";
import { useCallback, useMemo, useState } from "react";
import { Account } from "starknet";
import { Button } from "@/ui/elements/button";
import { Input } from "../elements/input";

export const Create = () => {
  const {
    account: { account },
    master,
    setup: {
      systemCalls: { create },
    },
  } = useDojo();

  const [isLoading, setIsLoading] = useState(false);
  const [name, setName] = useState("");

  const handleClick = useCallback(async () => {
    setIsLoading(true);
    try {
      await create({
        account: account as Account,
        name,
      });
    } finally {
      setIsLoading(false);
    }
  }, [account, name]);

  const disabled = useMemo(() => {
    return !account || !master || account === master || name === "";
  }, [account, master, name]);

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
        Create
      </Button>
    </div>
  );
};
