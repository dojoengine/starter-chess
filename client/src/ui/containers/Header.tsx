import { ModeToggle } from "@/ui/components/Theme";
import logo from "/assets/logo.png";
import { Pannel } from "../modules/Pannel";
import { useNavigate } from "react-router-dom";
import { useCallback } from "react";

export const Header = () => {
  const navigate = useNavigate();

  const setGameQueryParam = useCallback(
    () => navigate("", { replace: true }),
    [navigate],
  );

  return (
    <div className="w-full flex justify-between items-center px-8 py-2">
      <div className="flex gap-4 items-center">
        <Pannel />
        <div
          className="flex gap-4 items-center cursor-pointer"
          onClick={setGameQueryParam}
        >
          <img src={logo} alt="Chess" className="h-12" />
          <p className="text-4xl font-bold">Chess</p>
        </div>
      </div>
      <div className="flex gap-4 items-center">
        <ModeToggle />
      </div>
    </div>
  );
};
