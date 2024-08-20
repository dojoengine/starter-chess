import { create } from "zustand";

interface ActionStore {
  selection: number;
  setSelection: (selection: number) => void;
  resetSelection: () => void;
  to: number;
  setTo: (to: number) => void;
  resetTo: () => void;
}

export const useActionStore = create<ActionStore>()((set, get) => ({
  selection: 0,
  setSelection: (selection) => set({ selection }),
  resetSelection: () => set({ selection: 0 }),
  to: 0,
  setTo: (to) => set({ to }),
  resetTo: () => set({ to: 0 }),
}));
