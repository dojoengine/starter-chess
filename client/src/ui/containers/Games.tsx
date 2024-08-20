import { useGames } from "@/hooks/useGames";
import { Join } from "@/ui/actions/Join";
import { Carousel, CarouselContent } from "@/ui/elements/carousel";
import { Create } from "../actions/Create";
import { Game as GameClass } from "@/dojo/models/game";
import { useCallback, useMemo } from "react";
import { usePlayer } from "@/hooks/usePlayer";
import { Color, ColorType } from "@/dojo/types/color";
import { useNavigate } from "react-router-dom";
import { Button } from "../elements/button";

export const Games = () => {
  const { games } = useGames();

  return (
    <div className="flex flex-col items-stretch gap-4 w-full">
      <Create />
      <Carousel
        opts={{ align: "start", dragFree: true }}
        orientation="vertical"
        className="w-full"
      >
        <CarouselContent className="flex gap-4 my-4 h-[500px]">
          {games.reverse().map((game, key) => (
            <Game key={key} game={game} />
          ))}
        </CarouselContent>
      </Carousel>
    </div>
  );
};

export const Game = ({ game }: { game: GameClass }) => {
  const { player: white } = usePlayer({
    gameId: game.id,
    color: new Color(ColorType.White),
  });
  const { player: black } = usePlayer({
    gameId: game.id,
    color: new Color(ColorType.Black),
  });

  const filled = useMemo(() => !!white && !!black, [white, black]);

  const navigate = useNavigate();

  const setGameQueryParam = useCallback(
    (id: string) => navigate("?id=" + id, { replace: true }),
    [navigate],
  );

  const watch = useCallback(() => {
    setGameQueryParam(game.id.toString());
  }, [game]);

  if (!game) return null;

  return (
    <div className="px-4 py-2 flex justify-between gap-4 items-center border border-white">
      {`#${game.id}`}
      {!filled && <Join gameId={game.id} />}
      {filled && <Button onClick={watch}>Watch</Button>}
    </div>
  );
};
