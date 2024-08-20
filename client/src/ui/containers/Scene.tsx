import { useQueryParams } from "@/hooks/useQueryParams";
import { useGame } from "@/hooks/useGame";
import { useCallback, useMemo, useState } from "react";
import { Piece, PieceType } from "@/dojo/types/piece";
import { Color, ColorType } from "@/dojo/types/color";
import { useActionStore } from "@/store/selection";
import { Move } from "@/ui/actions/Move";
import { usePlayer } from "@/hooks/usePlayer";
import { useDojo } from "@/dojo/useDojo";

export const Scene = () => {
  const {
    account: { account },
  } = useDojo();
  const { gameId } = useQueryParams();
  const { game } = useGame({ gameId });
  const { player: white } = usePlayer({
    gameId,
    color: new Color(ColorType.White),
  });
  const { player: black } = usePlayer({
    gameId,
    color: new Color(ColorType.Black),
  });

  const isWhite = useMemo(() => {
    return account.address === white?.id;
  }, [account, white]);

  const isBlack = useMemo(() => {
    return account.address === black?.id;
  }, [account, black]);

  const size = useMemo(() => {
    return game?.getSize() ?? 0;
  }, [game]);

  const positions = useMemo(() => {
    return game?.getPositions() ?? {};
  }, [game]);

  if (!game || !size || !positions) return null;

  return (
    <div className="flex flex-col gap-4 items-center">
      <p className="text-4xl">
        {game.over
          ? "Game Over"
          : game.color.value === ColorType.White
            ? "White"
            : "Black"}
      </p>
      <div
        className={`w-[544px] flex flex-row gap-1 flex-wrap-reverse justify-center ${game.over && "grayscale"}`}
      >
        {Array.from(Array(size).keys()).map((col: number) =>
          Array.from(Array(size).keys()).map((row: number) => (
            <Cell
              key={`${row}-${col}`}
              row={row}
              col={col}
              index={game.getIndex(row, col)}
              over={game.over}
              white={isWhite}
              black={isBlack}
              item={positions[game.getIndex(row, col)]}
            />
          )),
        )}
      </div>
      <Move />
    </div>
  );
};

export const Cell = ({
  row,
  col,
  index,
  over,
  white,
  black,
  item,
}: {
  row: number;
  col: number;
  index: number;
  over: boolean;
  white: boolean;
  black: boolean;
  item: { piece: PieceType; color: ColorType };
}) => {
  const { selection, setSelection, to, setTo, resetTo } = useActionStore();
  const [hoverShadow, setHoverShadow] = useState("");

  const color = useMemo(() => {
    if (selection == index) return "bg-indigo-500";
    if (to == index) return "bg-red-500";
    return (row + col) % 2 === 0 ? "bg-[#C29F82]" : "bg-[#F3E1C2]";
  }, [row, col, selection, to, index]);

  const image = useMemo(() => {
    if (!item || item.piece == PieceType.None || item.color == ColorType.None)
      return "";
    const piece = new Piece(item.piece);
    return piece.getImage(item.color);
  }, [item]);

  const handleSelect = useCallback(() => {
    if (over) return;
    if (
      !item ||
      item.piece == PieceType.None ||
      item.color == ColorType.None ||
      (white && item.color == ColorType.Black) ||
      (black && item.color == ColorType.White)
    ) {
      setTo(index);
    } else {
      setSelection(index);
      resetTo();
    }
  }, [item, index, setSelection, white, black, over]);

  const onMouseEnter = useCallback(() => {
    if (over) return;
    if (
      !item ||
      item.piece == PieceType.None ||
      item.color == ColorType.None ||
      (white && item.color == ColorType.Black) ||
      (black && item.color == ColorType.White)
    ) {
      setHoverShadow("shadow-inner shadow-red-500/80");
    } else {
      setHoverShadow("shadow-inner shadow-indigo-500/80");
    }
  }, [item, index, setHoverShadow, white, black, over]);

  const onMouseLeave = useCallback(() => {
    setHoverShadow("");
  }, [setHoverShadow]);

  return (
    <div
      className={`w-[64px] h-[64px] flex justify-center items-center ${color} ${hoverShadow}`}
      onClick={handleSelect}
      onMouseEnter={onMouseEnter}
      onMouseLeave={onMouseLeave}
    >
      {!!item && <img src={image} alt="piece" className="w-[64px] h-[64px]" />}
    </div>
  );
};
