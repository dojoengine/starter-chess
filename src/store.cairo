//! Store struct and component management methods.

// Core imports

use core::debug::PrintTrait;

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Models imports

// use chess::models::index::{PlayerStore};
use chess::models::player::{Player, PlayerTrait};
use chess::models::game::{Game, GameTrait};

/// Store struct.
#[derive(Copy, Drop)]
struct Store {
    world: IWorldDispatcher,
}

/// Implementation of the `StoreTrait` trait for the `Store` struct.
#[generate_trait]
impl StoreImpl of StoreTrait {
    #[inline]
    fn new(world: IWorldDispatcher) -> Store {
        Store { world: world }
    }

    #[inline]
    fn player(self: Store, game_id: u32, color_id: u8) -> Player {
        get!(self.world, (game_id, color_id), (Player))
    }

    #[inline]
    fn game(self: Store, game_id: u32) -> Game {
        get!(self.world, game_id, (Game))
    }

    #[inline]
    fn set_player(self: Store, player: Player) {
        set!(self.world, (player))
    }

    #[inline]
    fn set_game(self: Store, game: Game) {
        set!(self.world, (game))
    }
}
