// Core imports

use core::debug::PrintTrait;

// Starknet imports

use starknet::testing::{set_contract_address, set_transaction_hash};

// Dojo imports

use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait};

// Internal imports

use chess::store::{Store, StoreTrait};
use chess::models::player::{Player, PlayerTrait};
use chess::models::game::{Game, GameTrait};
use chess::types::color::Color;
use chess::systems::actions::IActionsDispatcherTrait;

// Test imports

use chess::tests::setup::{setup, setup::{Systems, PLAYER, ANYONE}};

#[test]
fn test_actions_setup() {
    // [Setup]
    let (world, _, context) = setup::spawn_game();
    let store = StoreTrait::new(world);

    // [Assert]
    let game = store.game(context.game_id);
    assert(game.id == context.game_id, 'Setup: game id');
    let white = store.player(context.game_id, Color::White.into());
    assert(white.id == context.player_id, 'Setup: white id');
    let black = store.player(context.game_id, Color::Black.into());
    assert(black.id == context.anyone_id, 'Setup: black id');
}
