import { Menu } from "lucide-react";
import { Games } from "../containers/Games";
import { useMemo } from "react";
import { Account } from "@/ui/components/Account";
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetFooter,
  SheetHeader,
  SheetTitle,
  SheetTrigger,
} from "@/ui/elements/sheet";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import {
  faDiscord,
  faXTwitter,
  faGithub,
} from "@fortawesome/free-brands-svg-icons";
import { Button } from "../elements/button";

export const Pannel = () => {
  const links = useMemo(
    () => [
      {
        name: "Github",
        url: "https://github.com/dojoengine/starter-chess",
        icon: faGithub,
      },
      {
        name: "Twitter",
        url: "https://x.com/ohayo_dojo",
        icon: faXTwitter,
      },
      {
        name: "Discord",
        url: "https://discord.gg/dojoengine",
        icon: faDiscord,
      },
    ],
    [],
  );

  return (
    <Sheet>
      <SheetTrigger asChild className="cursor-pointer">
        <Button variant="outline" size="icon">
          <Menu className="h-[1.2rem] w-[1.2rem] rotate-0 scale-100 transition-all" />
          <span className="sr-only">Open menu</span>
        </Button>
      </SheetTrigger>
      <SheetContent side="left" className="flex flex-col justify-between">
        <SheetHeader>
          <SheetTitle className="text-3xl">Menu</SheetTitle>
          <SheetDescription className="font-['Indie Flower'] text-xl">
            Manage your account and your games
          </SheetDescription>
          <div className="flex flex-col gap-8 py-8 w-full">
            <div className="flex flex-col gap-2 items-start w-full">
              <p className="text-2xl">Account</p>
              <Account />
            </div>
            <div className="flex flex-col gap-2 items-start w-full">
              <p className="text-2xl">Games</p>
              <Games />
            </div>
          </div>
        </SheetHeader>
        <SheetFooter>
          <div className="w-full flex justify-center gap-8">
            {links.map((link, index) => (
              <a
                key={index}
                className="flex justify-center items-center hover:scale-105 duration-200"
                href={link.url}
                target="_blank"
              >
                <FontAwesomeIcon icon={link.icon as any} className="h-6" />
              </a>
            ))}
          </div>
        </SheetFooter>
      </SheetContent>
    </Sheet>
  );
};
