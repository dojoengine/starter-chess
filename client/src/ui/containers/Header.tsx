import { ModeToggle } from "@/ui/components/Theme";
import logo from "/assets/logo.png";
import { Pannel } from "../modules/Pannel";

export const Header = () => {
  return (
    <div className="w-full flex justify-between items-center px-8 py-2">
      <div className="flex gap-4 items-center">
        <Pannel />
        <img src={logo} alt="Chess" className="h-12" />
        <p className="text-4xl font-bold">Chess</p>
      </div>
      <div className="flex gap-4 items-center">
        <ModeToggle />
      </div>
    </div>
  );
};
