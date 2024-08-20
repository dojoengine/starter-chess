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
fn test_actions_move() {
    // [Setup]
    let (_, systems, context) = setup::spawn_game();

    // [Move] White
    set_contract_address(PLAYER());
    systems.actions.move(context.game_id, 0x8, 17);

    // [Move] Black
    set_contract_address(ANYONE());
    systems.actions.move(context.game_id, 0x10, 41);

    // [Move] White
    set_contract_address(PLAYER());
    systems.actions.move(context.game_id, 0x8, 25);

    // [Move] Black
    set_contract_address(ANYONE());
    systems.actions.move(context.game_id, 0x10, 33);
}
